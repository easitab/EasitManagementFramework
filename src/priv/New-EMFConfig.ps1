function New-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EMFHome = "$Home\EMF",
        
        [Parameter()]
        [string] $ConfigurationFileName = 'config.xml',
        
        [Parameter(Mandatory)]
        [string] $ConfigurationName,

        [Parameter(Mandatory)]
        [string] $SystemUUID,

        [Parameter(Mandatory)]
        [hashtable] $ConfigSettings,

        [Parameter()]
        [switch ] $ValidateConfig
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $emfConfigFilePath = "$EMFHome\$ConfigurationFileName"
        if (Test-Path "$emfConfigFilePath") {
            Write-Warning -Message "$emfConfigFilePath already exists. This will overwrite all settings!"
        } else {
            Write-Verbose "$emfConfigFilePath does not exist."
        }

        if (!(Test-Path -Path $EMFHome)) {
            New-Item -Path "$Home" -Name 'EMF' -ItemType Directory
            Write-Verbose -Message "Created directory EMF in $Home"
        } else {
            Write-Verbose "Found $EMFHome"
        }

        try {
            Write-Verbose "Creating xml element for systems"
            $configObjectItems = $configObject.CreateElement("systems")
            $configObject.AppendChild($configObjectItems) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for systems" -ErrorAction Continue
            Write-Error "$_"
            break
        }
        try {
            Write-Verbose "Creating xml element for $ConfigName"
            $configObjectItem = $configObject.CreateElement("$ConfigName")
            $configObjectItems.AppendChild($configObjectItem) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for $ConfigName" -ErrorAction Continue
            Write-Error "$_"
            break
        }
        foreach ($setting in $ConfigSettings.GetEnumerator()) {
            $settingName = $setting.Name
            $settingValue = $setting.Value
            try {
                Write-Verbose "Creating xml element for setting $settingName"
                $configObjectItemSetting = $configObject.CreateElement("$settingName")
                $configObjectItemSetting.InnerText = $settingValue
                $configObjectItem.AppendChild($configObjectItemSetting) | Out-Null
            } catch {
                Write-Error "Failed to create xml element for $settingName" -ErrorAction Continue
                Write-Error "$_"
                break
            }
        }
        try {
            $configObject.Save("$emfConfigFilePath")
            Write-Verbose -Message "Saved config to $emfConfigFilePath"
        } catch {
            Write-Error $_
        }

    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}