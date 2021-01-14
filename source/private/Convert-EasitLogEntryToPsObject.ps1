function Convert-EasitLogEntryToPsObject {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Convert-EasitLogEntryToPsObject.md")]
    param (
        [Parameter(ValueFromPipeline)]
        [string] $String
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        Write-Verbose "Selecting strings from entry"
        $stringDate = Select-String -InputObject $String -Pattern '\d{4}-\d{2}-\d{2}'
        $stringDate = "$($stringDate.Matches.Value)"
        Write-Debug "stringDate = $stringDate"

        $stringTime = Select-String -InputObject $String -Pattern '\d{2}:\d{2}:\d{2}\.\d{3}'
        $stringTime = "$($stringTime.Matches.Value)"
        Write-Debug "stringTime = $stringTime"

        $stringLevel = Select-String -InputObject $String -Pattern 'FATAL|ERROR|WARN|INFO|DEBUG|TRACE'
        $stringLevel = "$($stringLevel.Matches.Value)"
        Write-Debug "stringLevel = $stringLevel"

        $stringMessage = Select-String -InputObject $String -Pattern '- .+\['
        $stringMessage = "$($stringMessage.Matches.Value)"
        $stringMessage = $stringMessage.TrimStart('- ')
        $stringMessage = $stringMessage.TrimEnd('[')
        Write-Debug "stringMessage = $stringMessage"

        $stringClass = Select-String -InputObject $String -Pattern '\[.+\]'
        $stringClass = "$($stringClass.Matches.Value)"
        $stringClass = $stringClass.TrimStart('[')
        $stringClass = $stringClass.TrimEnd(']')
        Write-Debug "stringClass = $stringClass"

        $stringStack = Select-String -InputObject $String -Pattern '\- [\w|\W|\n\r]*'
        $stringStack = "$($stringStack.Matches.Value)"
        $stringStack = $stringStack.TrimStart("- $stringMessage [$stringClass]")
        $stringStack = $stringStack.TrimStart()
        Write-Debug "stringStack = $stringStack"
        Write-Verbose "Creating object from entry strings"
        $returnObject = [PSCustomObject]@{
            Date                = "$stringDate"
            Time                = "$stringTime"
            Level               = "$stringLevel"
            Class               = "$stringClass"
            Message             = "$stringMessage"
            FullStackMessage    = "$stringStack"
        }
        Write-Verbose "Returning entry as object"
        return $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}