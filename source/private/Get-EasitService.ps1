function Get-EasitService {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ServiceName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        try {
            $service = Get-CimInstance -ClassName Win32_Service -Filter "Name Like '$ServiceName'"
            Write-Verbose "Found service $($service.Name)"
        } catch {
            throw "Unable to find a service with a name like $ServiceName"
        }
        return $service
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}