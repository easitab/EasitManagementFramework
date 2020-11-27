function Import-EMFXMLData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter()]
        [switch] $Validate
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        Write-Verbose "Process block start"
        $xml = New-Object System.Xml.XmlDocument
        try {
            $xml.Load($Path)
            Write-Verbose 'Loaded XML-file to XML-object'
        } catch {
            throw $_
        }
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
        
        
        return $xml
        Write-Verbose "Process block end"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
