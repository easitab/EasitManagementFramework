function Convert-XmlToPSObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [xml] $XmlObject,
        [Parameter()]
        [switch] $SystemProperties
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $returnObject = New-Object -TypeName PSObject
        if ($SystemProperties) {
            foreach ($entry in $XmlObject.properties.entry) {
                Write-Verbose "Adding $($entry.key) = $($entry.'#text')"
                try {
                    Add-Member -InputObject $returnObject -MemberType Noteproperty -Name "$($entry.key)" -Value "$($entry.'#text')"
                } catch {
                    throw $_
                }
            }
        }
        return $returnObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}