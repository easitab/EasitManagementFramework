function Start-EasitGOApplication {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter()]
        [string] $EmfConfigurationName = 'Dev',
        [Parameter()]
        [switch] $Verify,
        [Parameter()]
        [switch] $RunningElevated
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        if (!($RunningElevated)) {
            throw "Session is not running with elevated priviliges that is need to perfom this action"
        }
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
        try {
            $easitGoService = Get-EasitService -ServiceName "$easitGoServiceName"
        } catch {
            throw $_
        }
        if ($null -eq $easitGoService) {
            throw "Unable to find service with name like $easitGoServiceName"
        } else {
            Write-Verbose "Successfully got CimInstance for $easitGoServiceName"
        }
        Write-Verbose "Starting service $easitGoServiceName"
        try {
            $easitGoService = Set-EasitService -Service $easitGoService -Action 'StartService'
        } catch {
            throw $_
        }
        Write-Verbose -Message "Service $easitGoServiceName have been started and is running"
        if ($Verify) {
            $verificationFailed = $false
            Write-Verbose "Trying to verify connectivity"
            $tomcatConf = (Get-ChildItem -Path "$($emfConfig.SystemRoot)\*" - 'conf' -Directory -Recurse).Fullname
            if (!($tomcatConf)) {
                try {
                    $tomcatConf = (Get-ChildItem -Path "$($emfConfig.TomcatRoot)\*" - 'conf' -Directory -Recurse).Fullname
                } catch {
                    Write-Warning "Unable to find folder conf in $($emfConfig.TomcatRoot)"
                    $verificationFailed = $true
                }
                if (!($tomcatConf)) {
                    Write-Warning "Unable to find tomcatConf: $tomcatConf"
                    $verificationFailed = $true
                }
            }
            if (!($verificationFailed)) {
                $tomcatServerXMLPath = (Get-ChildItem -Path "$tomcatConf\*" -Include 'server.xml').FullName
                if ($tomcatServerXMLPath) {
                    try {
                        $tomcatServerXML = Import-EMFXMLData -Path "$tomcatServerXMLPath"
                    } catch {
                        Write-Warning "Unable to import server.xml, system connectivity not verified"
                        $verificationFailed = $true
                    }
                    $tomcatServerPort = "$($tomcatServerXML.Server.Port)"
                } else {
                    Write-Warning "Unable to get server.xml from $tomcatConf"
                    $verificationFailed = $true
                }
                if (!($verificationFailed)) {
                    try {
                        Start-Sleep -Seconds 15
                        $url = "http://localhost:${tomcatServerPort}/monitor/?type=alive"
                        Write-Verbose "Checking if application is alive"
                        $systemStatus = Invoke-WebRequest -Uri "$url" -UseBasicParsing -ErrorAction Stop
                    } catch {
                        Write-Warning "Unable to connect to system"
                    }
                    if (!($systemStatus.StatusCode -eq 200)) {
                        Write-Warning "easitGoService is started but the system is not reachable!"
                    }
                }
            }
            if ($verificationFailed) {
                Write-Warning "Unable to verify system connectivity"
            }
        }
        Write-Information "System is up and running!" -InformationAction Continue
        return $easitGoService
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}