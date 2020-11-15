function Stop-EasitGOApplication {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter()]
        [string] $EmfConfigurationName = 'Prod'
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
        Write-Verbose "Stopping easitGoService...."
    try {
        Invoke-CimMethod -InputObject $easitGoService -MethodName StopService | Out-Null
        Start-Sleep -Seconds 15
        do {
            Write-Verbose "Waiting for easitGoService to stop"
            Start-Sleep -Seconds 15
            $systemToStop = Get-CimInstance -InputObject $easitGoService
        } while (!($systemToStop.State -eq 'Stopped'))
    } catch {
        throw $_
    }
    Write-Verbose "easitGoService stopped"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}