function Get-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",
        
        [Parameter()]
        [Alias('file','filename')]
        [string] $ConfigurationFileName = 'emfConfig.xml',

        [Parameter(Mandatory, Position=0)]
        [Alias('ConfigName')]
        [string] $ConfigurationName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        Write-Verbose "Process block start"
        if (Test-Path "$EMFHome\$ConfigurationFileName") {
            Write-Verbose "Found $EMFHome\$ConfigurationFileName"
        } else {            
            throw [System.IO.FileNotFoundException] "$EMFHome\$ConfigurationFileName does not exist"
        }
        Write-Verbose "Retrieving configurations data"
        try {
            $configurationFileData = Import-EMFXMLData -Path "$EMFHome\$ConfigurationFileName"
            Write-Verbose "Configuration data retrieved"
        } catch {
            throw $_
        }
        if ($configurationFileData.systems.$ConfigurationName) {
            Write-Verbose "Found configuration named $ConfigurationName"
        } else {
            throw "No configuration found named $ConfigurationName"
        }
        $returnObject = New-Object -TypeName psobject
        $configProperties = $configurationFileData.systems.$ConfigurationName
        foreach ($property in $configProperties.ChildNodes) {
            $returnObject | Add-Member -MemberType NoteProperty -Name "$($property.Name)" -Value "$($property.InnerText)"
        }
        return $returnObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
