function Start-EasitGOApplication {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter()]
        [string] $EmfConfigurationName = 'Prod',

        [Parameter()]
        [switch] $Verify
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        try {
            $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            Write-Verbose "Found EMF Config"
            $easitGoServiceName = "$($emfConfig.ServiceName)"
            Write-Verbose "ServiceName is $($emfConfig.ServiceName)"
        } catch {
            throw $_
        }
    }
    
    process {
        $tomcatConf = Join-Path -Path "$($emfConfig.TomcatRoot)" -ChildPath 'conf'
        $tomcatServerXMLPath = Join-Path -Path "$tomcatConf" -ChildPath 'server.xml'
        $tomcatServerXML = Import-EMFXMLData -Path "$tomcatServerXMLPath"
        $tomcatServerPort = "$($tomcatServerXML.Server.Port)"
        try {
            $easitGoService = Get-CimInstance -ClassName Win32_Service -Filter "Name Like '$easitGoServiceName'"
        } catch {
            throw $_
        }
        if ($null -eq $easitGoService) {
            throw "Unable to find service with name like $easitGoServiceName"
        } else {
            Write-Verbose "Successfully got CimInstance for $systemName"
        }
        Write-Verbose "Starting easitGoService...."
        try {
            Invoke-CimMethod -InputObject $easitGoService -MethodName StartService | Out-Null
            $waitingTime = 0
            do {
                Write-CustomLog -Message "Waiting for easitGoService to receive state 'Running'" -Level INFO
                Start-Sleep -Seconds 15
                $waitingTime += 15
                $systemToStart = Get-CimInstance -InputObject $easitGoService
            } while ($systemToStart.State -ne 'Running' -AND $waitingTime -le 240)
            if ($waitingTime -gt 240) {
                Write-Warning 'Time to start easitGoService exceeded 2 minutes, sending error!'
                continue
            }
        } catch {
            throw $_
        }
        Write-Verbose -Message "easitGoService started and running!"
        if ($Verify) {
            try {
                $url = "http://localhost:${$tomcatServerPort}/monitor/?type=alive"
                Write-Verbose "Checking if application is alive"
                $systemStatus = Invoke-WebRequest -Uri "$url" -UseBasicParsing -ErrorAction Stop
            } catch {
                throw $_
            }
            if ($systemStatus.StatusCode -eq 200) {
                Write-Output "Application is up and running!"
            } else {
                Write-Error "easitGoService is started but the application in not reachable!"
            }
        }
        return $systemToStart
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}