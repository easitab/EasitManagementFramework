function Convert-EmailRequestConfigfile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        try {
            $xmlObject = New-Object XML
        } catch {
            throw $_
        }
        if (Test-Path $Path) {
            try {
                $xmlObject.Load($Path)
            } catch {
                throw $_
            }
        } else {
            throw "Unable to find $Path"
        }
        foreach ($entry in $xmlObject.configuration.entries.GetEnumerator()) {
            try {
                $erMailConfigAsPSObject = New-Object PSObject
            } catch {
                throw $_
            }
            foreach ($mainProperty in $entry.properties.GetEnumerator()) {
                Write-Verbose "Adding property $($mainProperty.name) = $($mainProperty.value)"
                Add-Member -InputObject $erMailConfigAsPSObject -MemberType NoteProperty -Name "$($mainProperty.name)" -Value "$($mainProperty.value)"
            }
            foreach ($sourceProperty in $entry.source.properties.GetEnumerator()) {
                Write-Verbose "Adding property $($sourceProperty.name) = $($sourceProperty.value)"
                Add-Member -InputObject $erMailConfigAsPSObject -MemberType NoteProperty -Name "$($sourceProperty.name)" -Value "$($sourceProperty.value)"
            }
            foreach ($destinationProperty in $entry.destination.properties.GetEnumerator()) {
                Write-Verbose "Adding property $($destinationProperty.name) = $($destinationProperty.value)"
                Add-Member -InputObject $erMailConfigAsPSObject -MemberType NoteProperty -Name "$($destinationProperty.name)" -Value "$($destinationProperty.value)"
            }
            Write-Verbose "Adding property sourceType = $($entry.source.type)"
            Add-Member -InputObject $erMailConfigAsPSObject -MemberType NoteProperty -Name 'sourceType' -Value "$($entry.source.type)"
            Add-Member -InputObject $erMailConfigAsPSObject -MemberType NoteProperty -Name 'Path' -Value "$Path"
            $erMailConfigAsPSObject
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}