function Test-ConfigurationSetting {
    [CmdletBinding()]
    param (
        [Parameter()]
        [hashtable]$Hashtable,
        [Parameter()]
        [System.Xml.XmlDocument]$XmlObject
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $validatePathSetting = 'SystemRoot','EmailRequestRoot','EasitRoot','BackupRoot','TomcatRoot','ImportClientRoot','UpdateResourceDirectory'
    }
    
    process {
        $allSettingsPassedTest = $true
        if ($Hashtable) {
            foreach ($configSetting in $configurationSettings.GetEnumerator()) {
                $configSettingName = "$($configSetting.Key)"
                $configSettingValue = "$($configSetting.Value)"
                Write-Verbose "Validating configuration setting $configSettingName"
                if ($configSettingName -in $validatePathSetting) {
                    if (Test-Path "$configSettingValue" -IsValid) {
                        $validationResult = Test-Path "$configSettingValue"
                    } else {
                        $validationResult = $false
                    }
                }
                if ($configSettingName -eq 'ServiceName') {
                    $validationResult = Get-Service -Name "$configSettingValue" -ErrorAction SilentlyContinue
                }
                if ($configSettingName -eq 'WarName') {
                    $systemRoot = $configurationSettings['SystemRoot']
                    $validationResult = Get-ChildItem -Path "$systemRoot" -Recurse -Include "${configSettingValue}.war" -ErrorAction SilentlyContinue
                }
                if ($configSettingName -eq 'StoredBackupProcedure') {
                    # Unable to validate this setting
                    $validationResult = $true
                }
                if (!($validationResult)) {
                    Write-Warning "Configuration setting $configSettingName ($configSettingValue) failed validation"
                    $allSettingsPassedTest = $false
                }
            }
            if ($allSettingsPassedTest) {
                Write-Information "Validation OK" -InformationAction Continue
            }
        }
        if ($XmlObject) {
            foreach ($system in $XmlObject.systems.ChildNodes) {
                Write-Information "Validating settings for configuration $($system.Name)" -InformationAction Continue
                foreach ($configSetting in $system.ChildNodes) {
                    $configSettingName = "$($configSetting.Name)"
                    $configSettingValue = "$($configSetting.InnerText)"
                    Write-Verbose "Validating configuration setting $configSettingName"
                    if ($configSettingName -in $validatePathSetting) {
                        if (Test-Path "$configSettingValue" -IsValid) {
                            $validationResult = Test-Path "$configSettingValue"
                        } else {
                            $validationResult = $false
                        }
                    }
                    if ($configSettingName -eq 'ServiceName') {
                        $validationResult = Get-Service -Name "$configSettingValue" -ErrorAction SilentlyContinue
                    }
                    if ($configSettingName -eq 'WarName') {
                        $systemRoot = $system.GetElementsByTagName('SystemRoot')
                        $systemRoot = $systemRoot.'#text'
                        $validationResult = Get-EasitWarFile -Path "$systemRoot" -Name "${configSettingValue}.war"
                    }
                    if (!($validationResult)) {
                        Write-Warning "Configuration setting $configSettingName ($configSettingValue) failed validation"
                        $allSettingsPassedTest = $false
                    }
                }
                if ($allSettingsPassedTest) {
                    Write-Information "Validation OK" -InformationAction Continue
                }
            }
        }
        return
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}