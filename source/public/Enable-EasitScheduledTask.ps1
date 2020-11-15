function Enable-EasitScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'InputObject')]
        [Microsoft.Management.Infrastructure.CimInstance[]] $InputObject,

        [Parameter(ParameterSetName = 'TaskName')]
        [string[]] $TaskName,

        [Parameter()]
        [switch] $AsJob
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ($InputObject) {
            $paramArgs = @{
                TaskName = "$($InputObject.TaskName)"
            }
            Write-Verbose "TaskName set to $($InputObject.TaskName)"
        } 
        if ($TaskName) {
            $paramArgs = @{
                TaskName = "$TaskName"
            }
            Write-Verbose "TaskName set to $TaskName"
        }
        if ($AsJob) {
            $paramArgs = @{
                AsJob = $true
            }
            Write-Verbose "Parameter AsJob specified"
        }
        try {
            Enable-ScheduledTask @paramArgs
            Write-Verbose "Task with name $TaskName enabled"
        } catch {
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}