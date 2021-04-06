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
        $tomcatConf = Join-Path -Path "$($emfConfig.TomcatRoot)" -ChildPath 'conf'
        $tomcatServerXMLPath = Join-Path -Path "$tomcatConf" -ChildPath 'server.xml'
        $tomcatServerXML = Import-EMFXMLData -Path "$tomcatServerXMLPath"
        $tomcatServerPort = "$($tomcatServerXML.Server.Port)"
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
            try {
                $url = "http://localhost:${tomcatServerPort}/monitor/?type=alive"
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
        return $easitGoService
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}