function Set-EasitService {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [CimInstance] $Service,
        [Parameter(Mandatory)]
        [ValidateSet('StartService','StopService')]
        [string] $Action
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $waitingTime = 0
    }
    
    process {
        if ($Action -eq 'StartService') {
            $waitForServiceState = 'Running'
        }
        if ($Action -eq 'StopService') {
            $waitForServiceState = 'Stopped'
        }
        Write-Information "Invoking method $Action on $($Service.Name)"
        try {
            Invoke-CimMethod -InputObject $Service -MethodName "$Action" | Out-Null
        } catch {
            throw $_
        }
        try {
            do {
                Write-Verbose "Waiting for service to complete method invokation"
                Start-Sleep -Seconds 5
                $waitingTime += 5
                $serviceToCheck = Get-CimInstance -InputObject $Service
            } while ($serviceToCheck.State -ne "$waitForServiceState" -AND $waitingTime -le 240)
            if ($waitingTime -gt 240) {
                Write-Warning "Time to invoke method $Action exceeded 2 minutes"
            }
        } catch {
            throw $_
        }
        return $serviceToCheck
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}