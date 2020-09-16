function Import-EMFXMLData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $xml = New-Object System.Xml.XmlDocument
        try {
            $xml.Load($Path)
            Write-Verbose 'Loaded XML-file to XML-object'
        } catch {
            throw $_
        }

        try {
            Test-EMFXMLData -Path $Path
            Write-Verbose 'XML validated successfully'
        } catch {
            throw $_
        }
        
        return $xml
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}