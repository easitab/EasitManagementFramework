function Get-EasitScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch] $EmailRequest,

        [Parameter()]
        [switch] $ImportClient
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $easitTasks = @()
        if (!($EmailRequest) -and !($ImportClient)) {
            try {
                $easitTasks = Get-ScheduledTask -TaskName "*easit*"
            } catch {
                throw $_
            }
        }
        if ($EmailRequest) {
            try {
                $easitErTask = Get-ScheduledTask -TaskName "*easit*" | Where-Object -Property 'TaskName' -Match -Value '*mail*'
                $easitTasks += $easitErTask
            } catch {
                throw $_
            }
        }
        if ($ImportClient) {
            try {
                $easitIcTask = Get-ScheduledTask -TaskName "*easit*" | Where-Object -Property 'TaskName' -Match -Value '*import*'
                $easitTasks += $easitIcTask
            } catch {
                throw $_
            }
        }
        foreach ($task in $easitTasks) {
            $taskDetails = Get-ScheduledTaskInfo -InputObject $task
            $taskDetails | Add-Member -NotePropertyName Status -NotePropertyValue $task.State
            $taskDetails | Format-Table TaskName, LastRunTime, NextRunTime, Status -AutoSize
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}