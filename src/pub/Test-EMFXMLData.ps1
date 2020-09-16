function Test-EMFXMLData {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",

        [Parameter()]
        [string] $Path = "$EMFHome\config.xml",

        [Parameter()]
        [string] $SchemaFile = "$EMFHome\schema.xsd"
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if (Test-Path $Path) {
            Write-Verbose "Found $Path"
        } else {
            Write-Verbose "Unable to find $Path"
        }
        if (Test-Path $SchemaFile) {
            Write-Verbose "Found $SchemaFile"
        } else {
            throw $_
        }
        [scriptblock] $ValidationEventHandler = { Write-Error $args[1].Exception.InnerExceptionMessage }
        $schemaReader = New-Object System.Xml.XmlTextReader $SchemaFile
        $schema = [System.Xml.Schema.XmlSchema]::Read($schemaReader, $ValidationEventHandler)

        $xml = New-Object System.Xml.XmlDocument
        Write-Verbose 'Created XML-object'
        try {
            $xml.Schemas.Add($schema) | Out-Null
            Write-Verbose 'Added schema to XML-object'
        } catch {
            $schemaReader.Close()
            throw $_
        }
        try {
            $xml.Load($Path)
            Write-Verbose 'Loaded XML-file to XML-object'
        } catch {
            $schemaReader.Close()
            throw $_
        }
        try {
            Write-Verbose "Validating $Path against $SchemaFile"
            $xml.Validate({
                throw ($Exception = $args[1].Exception)
            })
            Write-Verbose "XML validate without errors"
            return $true
        } catch {
            $schemaReader.Close()
            throw $_
        }
    }
    
    end {
        $schemaReader.Close()
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}