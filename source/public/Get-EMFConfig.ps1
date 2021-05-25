function Get-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",
        
        [Parameter()]
        [Alias('ConfigurationFileName','ConfigFile','ConfigFileName')]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter(Mandatory, Position=0)]
        [Alias('ConfigurationName','ConfigName')]
        [string] $EmfConfigurationName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if (Test-Path "$EMFHome\$EmfConfigurationFileName") {
            Write-Verbose "Found $EMFHome\$EmfConfigurationFileName"
        } else {            
            throw [System.IO.FileNotFoundException] "$EMFHome\$EmfConfigurationFileName does not exist"
        }
        Write-Verbose "Retrieving configurations data"
        try {
            $configurationFileData = Import-EMFXMLData -Path "$EMFHome\$EmfConfigurationFileName"
            Write-Verbose "Configuration data retrieved"
        } catch {
            throw $_
        }
        if ($configurationFileData.systems.$EmfConfigurationName) {
            Write-Verbose "Found configuration named $EmfConfigurationName"
        } else {
            throw "No configuration found named $EmfConfigurationName"
        }
        $returnObject = New-Object -TypeName psobject
        $configProperties = $configurationFileData.systems.$EmfConfigurationName
        foreach ($property in $configProperties.ChildNodes) {
            $returnObject | Add-Member -MemberType NoteProperty -Name "$($property.Name)" -Value "$($property.InnerText)"
        }
        return $returnObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
