function Import-EMFXMLData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path,
        [Parameter()]
        [switch] $ReturnAsPSObject,
        [Parameter()]
        [switch] $Validate
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        Write-Verbose "Process block start"
        if ($Validate) {
            try {
                Test-EMFXMLData -Path $Path
                Write-Verbose 'XML validated successfully'
            } catch {
                throw $_
            }
        } else {
            Write-Verbose "Skipping validation"
        }
        $xmlObject = New-Object System.Xml.XmlDocument
        try {
            $xmlObject.Load($Path)
            Write-Verbose 'Loaded XML-file to XML-object'
        } catch {
            throw $_
        }
        
        if ($ReturnAsPSObject) {
            try {
                $psObject = Convert-XmlToPSObject -XmlObject $xml -SystemProperties
            } catch {
                throw $_
            }
            return $psObject
        } else {
            return $xmlObject
        }
        Write-Verbose "Process block end"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
