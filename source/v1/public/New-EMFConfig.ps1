function New-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "${env:ALLUSERSPROFILE}\EMF",
        
        [Parameter()]
        [Alias('ConfigurationFileName','ConfigFile','ConfigFileName')]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        
        [Parameter(Mandatory)]
        [ValidateSet("Prod","Test","Dev","IntegrationProd","IntegrationTest","IntegrationDev")]
        [Alias('ConfigurationName','ConfigName')]
        [string] $EmfConfigurationName,

        [Parameter(Mandatory)]
        [Alias('ConfigurationSettings','ConfigSettings')]
        [hashtable] $EmfConfigurationSettings,

        [Parameter()]
        [switch ] $Validate,

        [Parameter()]
        [string] $SchemaFile = "$EMFHome\emfConfig.xsd"
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $emfConfigFilePath = "$EMFHome\$EmfConfigurationFileName"
        if (Test-Path "$emfConfigFilePath") {
            Write-Verbose -Message "$emfConfigFilePath already exists."
            try {
                Get-EMFConfig -EMFHome $EMFHome -EmfConfigurationFileName $EmfConfigurationFileName -EmfConfigurationName $EmfConfigurationName
                Write-Warning "A configuration with the name $EmfConfigurationName does already exist in $emfConfigFilePath. Use Set-EMFConfig to update configuration!"
                break
            } catch {
                Write-Verbose "No configuration with name $EmfConfigurationName found"
            }
        } else {
            Write-Verbose "$emfConfigFilePath does not exist."
            if (!(Test-Path -Path $EMFHome)) {
                New-Item -Path "${env:ALLUSERSPROFILE}" -Name 'EMF' -ItemType Directory
                Write-Verbose -Message "Created directory EMF in ${env:ALLUSERSPROFILE}"
            } else {
                Write-Verbose "Found $EMFHome"
            }
        }
        try {
            Write-Verbose "Creating xml object for config"
            $configObject = New-Object System.Xml.XmlDocument
            [System.Xml.XmlDeclaration] $xmlDeclaration = $configObject.CreateXmlDeclaration("1.0", "UTF-8", $null)
            $configObject.AppendChild($xmlDeclaration) | Out-Null
        } catch {
            Write-Verbose "Failed to create xml object for payload"
            throw "$_"
        }
        try {
            Write-Verbose "Creating xml element for systems"
            $configObjectItems = $configObject.CreateElement('systems')
            $configObject.AppendChild($configObjectItems) | Out-Null
        } catch {
            Write-Verbose "Failed to create xml element for systems"
            throw $_
        }
        try {
            Write-Verbose "Creating xml element for $EmfConfigurationName"
            $configObjectItem = $configObject.CreateElement("$EmfConfigurationName")
            $configObjectItems.AppendChild($configObjectItem) | Out-Null
        } catch {
            Write-Verbose "Failed to create xml element for $EmfConfigurationName"
            throw $_
        }
        foreach ($setting in $ConfigurationSettings.GetEnumerator()) {
            $settingName = $setting.Name
            $settingValue = $setting.Value
            if (!($settingName -eq 'EmfConfigurationName')) {
                try {
                    Write-Verbose "Creating xml element for setting $settingName"
                    $configObjectItemSetting = $configObject.CreateElement("$settingName")
                    $configObjectItemSetting.InnerText = $settingValue
                    $configObjectItem.AppendChild($configObjectItemSetting) | Out-Null
                } catch {
                    Write-Verbose "Failed to create xml element for $settingName"
                    throw $_
                }
            } else {
                Write-Verbose "SettingName = EmfConfigurationName"
            }
        }

        if ($Validate) {
            $emfConfigFilePathTemp = "$EMFHome\temp.xml"
            $configObject.Save("$emfConfigFilePathTemp")
            try {
                Test-EMFXMLData -Path $emfConfigFilePathTemp -SchemaFile $SchemaFile
                Test-ConfigurationSetting -XmlObject $configObject
                Remove-Item $emfConfigFilePathTemp -Force | Out-Null
            } catch {
                Remove-Item $emfConfigFilePathTemp -Force | Out-Null
                throw $_
            }
        }

        try {
            $configObject.Save("$emfConfigFilePath")
            Write-Verbose -Message "Saved config to $emfConfigFilePath"
        } catch {
            throw "Unable to save config to $emfConfigFilePath"
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
