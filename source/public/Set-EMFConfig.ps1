function Set-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "${env:ALLUSERSPROFILE}\EMF",

        [Parameter()]
        [Alias('ConfigurationFileName','ConfigFile','ConfigFileName')]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter(Mandatory,Position=0)]
        [Alias('ConfigurationName','ConfigName')]
        [string] $EmfConfigurationName,

        [Parameter(Mandatory,ParameterSetName='Manual')]
        [string] $EasitRoot,

        [Parameter(ParameterSetName='Manual')]
        [string] $SystemRoot = "$EasitRoot\Systems\$EmfConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $ServiceName = "Easit$EmfConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $WarName = "ROOT",

        [Parameter(ParameterSetName='Manual')]
        [string] $TomcatRoot = "$EasitRoot\Systems\$EmfConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $BackupRoot = "$EasitRoot\_Backup\$EmfConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [Alias('ER','EmailRequest','erRoot')]
        [string] $EmailRequestRoot = "$EasitRoot\EmailRequest",

        [Parameter(ParameterSetName='Manual')]
        [Alias('IC','ImportClient','icRoot')]
        [string] $ImportClientRoot = "$EasitRoot\ImportClient",

        [Parameter(ParameterSetName='Manual')]
        [Alias('urd')]
        [string] $UpdateResourceDirectory = "$EasitRoot\Update",

        [Parameter(ParameterSetName='Manual')]
        [Alias('sbp')]
        [string] $StoredBackupProcedure = 'StoredBackupProcedureName',

        [Parameter(Mandatory,ParameterSetName='Array')]
        [string[]] $PropertySetting,
        [Parameter()]
        [switch]$ValidateSettings
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if (Test-Path "$EMFHome\$EmfConfigurationFileName") {
            Write-Verbose "Located $EMFHome\$EmfConfigurationFileName"
            try {
                $currentConfigSettings = Get-EMFConfig -EMFHome $EMFHome -EmfConfigurationFileName $EmfConfigurationFileName -EmfConfigurationName $EmfConfigurationName
                Write-Verbose "Successfully retrieved configuration"
            } catch {
                throw $_
            }
        } else {
            throw "Cannot find $EMFHome\$EmfConfigurationFileName"
        }
        $paramName = $PSCmdlet.ParameterSetName
        if ($paramName -eq 'Manual') {
            Write-Verbose "ParameterSetName = $paramName"
            $configurationSettings = [ordered]@{
                EasitRoot = "$EasitRoot"
                WarName = "$WarName"
                SystemRoot = "$SystemRoot"
                ServiceName = "$ServiceName"
                TomcatRoot = "$TomcatRoot"
                BackupRoot = "$BackupRoot"
                EmailRequestRoot = "$EmailRequestRoot"
                ImportClientRoot = "$ImportClientRoot"
                UpdateResourceDirectory = "$UpdateResourceDirectory"
                StoredBackupProcedure = "$StoredBackupProcedure"
            }
            Write-Verbose "Created hashtable with settings"
        } 
        if ($paramName -eq 'Array') {
            Write-Verbose "ParameterSetName = $paramName"
            try {
                foreach ($prop in $PropertySetting) {
                    $tempArray = $prop -split ','
                    $propName = ($tempArray[0]) -replace ' ', ''
                    $propValue = ($tempArray[1]) -replace ' ', ''
                    $currentConfigSettings | Add-Member -MemberType NoteProperty -Name "$propName" -Value "$propValue" -Force
                }
                Write-Verbose "Added new settings to CustomObject"
            } catch {
                throw $_
            }
            try {
                $configurationSettings = [ordered]@{}
                $currentConfigSettings | Get-Member -Type NoteProperty -ErrorAction Stop | ForEach-Object {
                    $value = $currentConfigSettings."$($_.Name)"
                    $configurationSettings.Add("$($_.Name)", "$value")
                }
            } catch {
                throw $_
            }
        }
        try {
            $currentConfigurationFile = New-Object System.Xml.XmlDocument
            $currentConfigurationFile.Load("$EMFHome\$EmfConfigurationFileName")
        } catch {
            Write-Verbose "Something went wrong while loading currentConfigurationFile"
            throw "$($_.Exception.Message)"
        }
        if (!($currentConfigurationFile.systems.${EmfConfigurationName})) {
            Write-Warning "Unable to find configuration block for $EmfConfigurationName"
            return
        }
        if ($ValidateSettings) {
            Test-ConfigurationSetting -Hashtable $configurationSettings
        }
        try {
            $configurationSettings.GetEnumerator() | ForEach-Object {
                $settingName = "$($_.Key)"
                $settingValue = "$($_.Value)"
                $currentConfigurationFile.systems.${EmfConfigurationName}.${settingName} = $settingValue
            }
        } catch {
            Write-Warning "$($_.Exception.Message)"
        }
        
        try {
            $currentConfigurationFile.Save("$EMFHome\$EmfConfigurationFileName")
        } catch {
            Write-Verbose "Something went wrong while updating configuration file ($EmfConfigurationFileName), block $EmfConfigurationName"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
