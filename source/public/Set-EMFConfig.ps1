function Set-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",

        [Parameter()]
        [Alias('file','filename')]
        [string] $ConfigurationFileName = 'emfConfig.xml',

        [Parameter(Mandatory,Position=0)]
        [Alias('ConfigName')]
        [string] $ConfigurationName,

        [Parameter(Mandatory,ParameterSetName='Manual')]
        [string] $EasitRoot,

        [Parameter(ParameterSetName='Manual')]
        [string] $SystemRoot = "$EasitRoot\Systems\$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $ServiceName = "Easit$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $WarName = "ROOT",

        [Parameter(ParameterSetName='Manual')]
        [string] $TomcatRoot = "$EasitRoot\Systems\$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $BackupRoot = "$EasitRoot\_Backup\$ConfigurationName",

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
        if (Test-Path "$EMFHome\$ConfigurationFileName") {
            Write-Verbose "Located $EMFHome\$ConfigurationFileName"
            try {
                $currentConfigSettings = Get-EMFConfig -EMFHome $EMFHome -ConfigurationFileName $ConfigurationFileName -ConfigurationName $ConfigurationName
                Write-Verbose "Successfully retrieved configuration"
            } catch {
                throw $_
            }
        } else {
            throw "Cannot find $EMFHome\$ConfigurationFileName"
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
            $currentConfigurationFile.Load("$EMFHome\$ConfigurationFileName")
        } catch {
            Write-Verbose "Something went wrong while loading currentConfigurationFile"
            throw "$($_.Exception.Message)"
        }
        if (!($currentConfigurationFile.systems.${ConfigurationName})) {
            Write-Warning "Unable to find configuration block for $ConfigurationName"
            return
        }
        if ($ValidateSettings) {
            Test-ConfigurationSetting -Hashtable $configurationSettings
        }
        try {
            $configurationSettings.GetEnumerator() | ForEach-Object {
                $settingName = "$($_.Key)"
                $settingValue = "$($_.Value)"
                $currentConfigurationFile.systems.${ConfigurationName}.${settingName} = $settingValue
            }
        } catch {
            Write-Warning "$($_.Exception.Message)"
        }
        
        try {
            $currentConfigurationFile.Save("$EMFHome\$ConfigurationFileName")
        } catch {
            Write-Verbose "Something went wrong while updating configuration file ($ConfigurationFileName), block $ConfigurationName"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
