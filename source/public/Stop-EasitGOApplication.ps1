function Stop-EasitGOApplication {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter()]
        [string] $EmfConfigurationName = 'Dev',
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
        Write-Verbose "Stopping service $easitGoServiceName"
        try {
            $easitGoService = Set-EasitService -Service $easitGoService -Action 'StopService'
        } catch {
            throw $_
        }
        Write-Verbose "Service $easitGoServiceName have been stopped"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}