function Invoke-EasitGOHealthCheck {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-EasitGOHealthCheck.md")]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter(Mandatory)]
        [Alias('system')]
        [string] $EmfConfigurationName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $emfConfig = Get-EMFConfig -EMFHome $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
    }
    
    process {
        $healthCheckResultObject = New-Object -TypeName PSObject
        if (Test-Path -Path "$($emfConfig.SystemRoot)") {
            Write-Verbose "Evalutating system drive.."
            try {
                $systemDriveLetter = Split-Path -Path "$($emfConfig.SystemRoot)" -Qualifier
            } catch {
                throw $_
            }
            if ($systemDriveLetter) {
                Write-Verbose "Using systemDriveLetter $systemDriveLetter to evaluate drive state"
                $systemDriveDetails = Get-CimInstance Win32_LogicalDisk -Filter DriveType=3 | Where-Object -Property DeviceID -EQ "$systemDriveLetter" | Select-Object DeviceID, @{'Name'='Size'; 'Expression'={[math]::truncate($_.size / 1GB)}}, @{'Name'='Freespace'; 'Expression'={[math]::truncate($_.freespace / 1GB)}}
                try {
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name EvaluatedDrive -Value "$systemDriveLetter"
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name DriveSize -Value "$($systemDriveDetails.Size)"
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name DriveFreespace -Value "$($systemDriveDetails.Freespace)"
                } catch {
                    Write-Warning "$($_.Exception)"
                }
            } else {
                Write-Warning "Unable to find systemDriveLetter, skipping evaluation of system drive"
            }
        } else {
            Write-Warning "Unable to find path for systemroot from emfConfig ($($emfConfig.SystemRoot)), skipping evalution of system drive"
        }
        Write-Verbose "Evalution of system drive complete"
        Write-Verbose "Evalutating system memory.."
        try {
            $memoryInfo = Get-CimInstance win32_physicalmemory
            $totalMemoryCapacity = ($memoryInfo | Measure-Object -Property capacity -Sum).sum /1gb
            $totalMemoryFree = [math]::round(((Get-CIMInstance Win32_OperatingSystem | Measure-Object -Property FreePhysicalMemory -Sum).sum /1024) /1024,2)
        } catch {
            throw $_
        }
        try {
            $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name TotalMemoryCapacity -Value "$totalMemoryCapacity"
            $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name TotalMemoryFree -Value "$totalMemoryFree"
        } catch {
            throw $_
        }
        Write-Verbose "Evalution of system memory complete"
        Write-Verbose "Evalutating system service.."
        if ($emfConfig.ServiceName) {
            try {
                $systemName = $emfConfig.serviceName
                $service = Get-CimInstance -ClassName Win32_Service -Filter "Name Like '$systemName'"
            } catch {
                throw $_
            }
            if ($service) {
                try {
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name ServiceState -Value "$($service.State)"
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name ServiceStatus -Value "$($service.Status)"
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name ServiceStartMode -Value "$($service.StartMode)"
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name ServiceProcessId -Value "$($service.ProcessId)"
                } catch {
                    throw $_
                }
                Write-Verbose "Evalution of system service complete"
            } else {
                Write-Warning "Unable to find system service with name $systemName"
            }
        } else {
            Write-Warning "ServiceName from emfConfig is invalid, skipping evalution of system service"
        }
        $systemPortFound = $false
        $systemPropertiesPathFound = $false
        if (Test-Path "$($emfConfig.SystemRoot)") {
            $systemPropertiesPath = Get-ChildItem -Path "$($emfConfig.SystemRoot)\*server.xml" -Recurse
            if ($systemPropertiesPath) {
                $systemPropertiesPathFound = $true
            }
        } 
        if (!($systemPropertiesPathFound)) {
            if (Test-Path "$($emfConfig.TomcatRoot)") {
                $systemPropertiesPath = Get-ChildItem -Path "$($emfConfig.TomcatRoot)\*server.xml" -Recurse
                if ($systemPropertiesPath) {
                    $systemPropertiesPathFound = $true
                }
            }
        }
        if ($systemPropertiesPathFound) {
            Write-Verbose "Evalutating ping and database response time.."
            try {
                $systemServerXML = Get-Content -Path "$systemPropertiesPath" -Raw
                $systemServerXML -imatch 'Connector port="(\d{4})" protocol="HTTP.*"' | Out-Null
                $systemPort = $Matches[1]
                $systemPortFound = $true
            } catch {
                Write-Warning "$($_.Exception)"
            }
            if ($systemPortFound) {
                $systemMonitorUrl = "http://localhost:${systemPort}/monitor/?bypassSSO=true"
                Write-Verbose "systemMonitorUrl = $systemMonitorUrl"
                try {
                    $systemStatus = Invoke-WebRequest -Uri "${systemMonitorUrl}&type=alive" -UseBasicParsing -ErrorAction Stop
                    Write-Verbose "Successfully connected to ${systemMonitorUrl}&type=alive"
                    $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name SystemStatusCode -Value "$($systemStatus.StatusCode)"
                } catch {
                    Write-Verbose "Unable to contact system monitor 'alive'"
                    Write-Verbose "$($_.Exception)"
                }
                Write-Verbose "Evalutating database response time.."
                try {
                    $dbLatency = Invoke-WebRequest -Uri "${systemMonitorUrl}&type=db" -UseBasicParsing -ErrorAction Stop
                    Write-Verbose "Successfully connected to ${systemMonitorUrl}&type=db"
                    if ($dbLatency.StatusCode -eq 200) {
                        $dbLatency.Content -match '1000 times:\s?(.*)\s?ms' | Out-Null
                        [int]$dbResponseTime = $Matches[1]
                        $healthCheckResultObject | Add-Member -MemberType NoteProperty -Name DatabaseResponseTime -Value "$dbResponseTime"
                    } else {
                        Write-Verbose "Unable to query for DB response time"
                    }
                } catch {
                    Write-Verbose "Unable to contact system monitor 'db'"
                    Write-Verbose "$($_.Exception)"
                }
            } else {
                Write-Warning "Unable to resolve system port"
            }
        } else {
            Write-Warning "Unable to find port for system. Skipping evaluation of ping and database response time"
        }
        return $healthCheckResultObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
