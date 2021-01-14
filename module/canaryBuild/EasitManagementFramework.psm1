function Disable-EasitScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'InputObject')]
        [Microsoft.Management.Infrastructure.CimInstance[]] $InputObject,

        [Parameter(ParameterSetName = 'TaskName')]
        [string[]] $TaskName,

        [Parameter()]
        [switch] $AsJob
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ($InputObject) {
            $paramArgs = @{
                TaskName = "$($InputObject.TaskName)"
            }
            Write-Verbose "TaskName set to $($InputObject.TaskName)"
        } 
        if ($TaskName) {
            $paramArgs = @{
                TaskName = "$TaskName"
            }
            Write-Verbose "TaskName set to $TaskName"
        }
        if ($AsJob) {
            $paramArgs = @{
                AsJob = $true
            }
            Write-Verbose "Parameter AsJob specified"
        }
        try {
            Disable-ScheduledTask @paramArgs
            Write-Verbose "Task with name $TaskName disabled"
        } catch {
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Enable-EasitScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, ParameterSetName = 'InputObject')]
        [Microsoft.Management.Infrastructure.CimInstance[]] $InputObject,

        [Parameter(ParameterSetName = 'TaskName')]
        [string[]] $TaskName,

        [Parameter()]
        [switch] $AsJob
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized.."
    }
    
    process {
        if ($InputObject) {
            $paramArgs = @{
                TaskName = "$($InputObject.TaskName)"
            }
            Write-Verbose "TaskName set to $($InputObject.TaskName)"
        } 
        if ($TaskName) {
            $paramArgs = @{
                TaskName = "$TaskName"
            }
            Write-Verbose "TaskName set to $TaskName"
        }
        if ($AsJob) {
            $paramArgs = @{
                AsJob = $true
            }
            Write-Verbose "Parameter AsJob specified"
        }
        try {
            Enable-ScheduledTask @paramArgs
            Write-Verbose "Task with name $TaskName enabled"
        } catch {
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Get-EasitEmailRequestMailbox {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter()]
        [string] $EmfConfigurationName = 'Prod',

        [Parameter()]
        [string] $EmailRequestConfigurationFilename = 'config.xml',

        [Parameter()]
        [Alias('Mailbox')]
        [string] $MailboxName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        try {
            $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            Write-Verbose "Found EMF Config"
        } catch {
            throw $_
        }
    }
    
    process {
        # Hmmm, this is not to effective. Same code as in Set-EasitEmailRequestMailboxSetting, will fix in version 2!!
        try {
            $erXmlConfigFile = Get-ChildItem -Path "$($emfConfig.EmailRequestRoot)" -Include "$EmailRequestConfigurationFilename" -Recurse -Force
            Write-Verbose "Found ER config."
        } catch {
            throw $_
        }
        try {
            $erConfig = Import-EMFXMLData -Path "$($erXmlConfigFile.FullName)"
            Write-Verbose "Imported configuration"
        } catch {
            throw $_
        }
        $mailboxes = @()
        if ($null -eq $MailboxName) {
            foreach ($mailboxConfig in $erConfig.configuration.entries.GetEnumerator()) {
                $mailbox = New-Object PSObject
                foreach ($property in $mailboxConfig.properties.GetEnumerator()) {
                    Add-Member -InputObject $mailbox -MemberType Noteproperty -Name "$($property.name)" -Value "$($property.value)"
                }
                foreach ($sourceProperty in $mailboxConfig.source.properties.GetEnumerator()) {
                    if ($sourceProperty.name -ne 'password') {
                        Add-Member -InputObject $mailbox -MemberType Noteproperty -Name "$($sourceProperty.name)" -Value "$($sourceProperty.value)"
                    }
                }
                foreach ($destProperty in $mailboxConfig.destination.properties.GetEnumerator()) {
                    Add-Member -InputObject $mailbox -MemberType Noteproperty -Name "$($destProperty.name)" -Value "$($destProperty.value)"
                }
                $mailboxes += $mailbox
            }
        } else { # Duplicate code again, will fix in version 2.
            try {
                $node = $erConfig.SelectNodes("//properties/property") | Where-Object {$_.name -eq "displayName"} | Where-Object {$_.value -eq "$MailboxName"}
            } catch {
                throw $_
            }
            try {
                $mailBoxNode = $node.ParentNode.ParentNode
                Write-Verbose "Found mailbox in configuration"
            } catch {
                throw $_
            }
            $mailbox = New-Object PSObject
            foreach ($property in $mailBoxNode.properties.GetEnumerator()) {
                Add-Member -InputObject $mailbox -MemberType Noteproperty -Name "$($property.name)" -Value "$($property.value)"
            }
            foreach ($sourceProperty in $mailBoxNode.source.properties.GetEnumerator()) {
                if ($sourceProperty.name -ne 'password') {
                    Add-Member -InputObject $mailbox -MemberType Noteproperty -Name "$($sourceProperty.name)" -Value "$($sourceProperty.value)"
                }
            }
            foreach ($destProperty in $mailBoxNode.destination.properties.GetEnumerator()) {
                Add-Member -InputObject $mailbox -MemberType Noteproperty -Name "$($destProperty.name)" -Value "$($destProperty.value)"
            }
            $mailboxes += $mailbox
        }
        $mailboxes
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Get-EasitLog {
    [CmdletBinding(DefaultParameterSetName='Configuration',HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Get-EasitLog.md")]
    param (
        [Parameter(ParameterSetName = 'LiteralPath')]
        [string]$LiteralPath,
        [Parameter(ParameterSetName = 'ContainerPath')]
        [string]$Path,
        [Parameter(ParameterSetName = 'ContainerPath')]
        [string]$LogFilename,
        [Parameter(ParameterSetName = 'Configuration')]
        [string] $EmfHome = "$Home\EMF",
        [Parameter(ParameterSetName = 'Configuration')]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter(ParameterSetName = 'Configuration')]
        [string] $EmfConfigurationName = 'Prod'
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!($LiteralPath) -and !($Path)) {
            Write-Verbose "LiteralPath and Path are not provided"
            try {
                Write-Verbose "Looking for EMF-Config"
                $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            } catch {
                throw $_
            }
            try {
                Write-Verbose "Joining path $($emfConfig.SystemRoot) and 'logs'"
                $Path = Join-Path "$($emfConfig.SystemRoot)" -ChildPath 'logs' -ErrorAction Stop
            } catch {
                throw $_
            }
            if (Test-Path -Path $Path) {
                Write-Verbose "Path = $Path"
            } else {
                Write-Verbose "Path = $Path"
                throw "Unable to find $Path. A valid path to logfiles need to be provided. This can be done with the following parameters 'LiteralPath' or 'Path'. If you would like to use your EMF-configurationfile place it in $Home\EMF and specify a value for SystemRoot (ex. D:\Easit\Systems\Prod) or use 'EmfHome', 'EmfConfigurationFileName' and 'EmfConfigurationName' parameters to take advantage from it."
            }
            
        } elseif ($Path) {
            if (Test-Path -Path $Path) {
                Write-Verbose "Path = $Path"
            } else {
                throw "Unable to find $Path"
            }
        } elseif ($LiteralPath) {
            if (Test-Path -Path $LiteralPath) {
                Write-Verbose "Getting content of $LiteralPath"
                try {
                    $logData = [System.IO.File]::ReadAllText($LiteralPath)
                    Write-Verbose "Content collected"
                } catch {
                    throw $_
                }
            } else {
                throw "Unable to find $LiteralPath"
            }
        } else {
            throw "Unable to figure out what to do. Either provide a 'LiteralPath', 'Path' and 'LogFilename' or a valid EMF-configurationfile"
        }
        if (!($LiteralPath)) {
            # If-block need to be performed for Get-ChildItem to work.
            if (Test-Path $Path -PathType Container) {
                if (!($Path -match '\\$')) {
                    $Path = "${Path}\"
                }
            }
            if ($LogFilename) {
                $gciParams = @{
                    Include = "*${LogFilename}*.log"
                    Exclude = $null
                }
            } else {
                $LogFilename = 'easit'
                $gciParams = @{
                    Include = '*easit*.log'
                    Exclude = '*err*', '*out*'
                }
            }
            try {
                $files = Get-ChildItem "${Path}*" @gciParams -ErrorAction Stop
                Write-Verbose "Collected all files matching *${LogFilename}*.log in $Path"
            } catch {
                throw $_
            }
            foreach ($file in $files) {
                Write-Verbose "Getting content of $file"
                try {
                    $logData += [System.IO.File]::ReadAllText($file)
                    Write-Verbose "Content collected"
                } catch {
                    throw $_
                }
            }
        }
        $returnObject = @()
        Write-Verbose "Splitting entries in logfile"
        $logEvents = $logData -split "(?=[\r|\n]+\d)"
        Write-Verbose "Converting entries to objects"
        foreach ($logEvent in $logEvents) {
            $logEvent = $logEvent.TrimEnd()
            $logEvent = $logEvent.TrimStart()
            if ($logEvent.length -gt 0) {
                try {
                    $returnObject += $logEvent | Convert-EasitLogEntryToPsObject
                } catch {
                    throw $_
                }
            }
        }
        Write-Verbose "Returning converted entries as objects"
        return $returnObject
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Get-EasitScheduledTask {
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch] $EmailRequest,

        [Parameter()]
        [switch] $ImportClient
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $easitTasks = @()
        if (!($EmailRequest) -and !($ImportClient)) {
            try {
                $easitTasks = Get-ScheduledTask -TaskName "*easit*"
            } catch {
                throw $_
            }
        }
        if ($EmailRequest) {
            try {
                $easitErTask = Get-ScheduledTask -TaskName "*easit*" | Where-Object -Property 'TaskName' -Match -Value '*mail*'
                $easitTasks += $easitErTask
            } catch {
                throw $_
            }
        }
        if ($ImportClient) {
            try {
                $easitIcTask = Get-ScheduledTask -TaskName "*easit*" | Where-Object -Property 'TaskName' -Match -Value '*import*'
                $easitTasks += $easitIcTask
            } catch {
                throw $_
            }
        }
        foreach ($task in $easitTasks) {
            $taskDetails = Get-ScheduledTaskInfo -InputObject $task
            $taskDetails | Add-Member -NotePropertyName Status -NotePropertyValue $task.State
            $taskDetails | Format-Table TaskName, LastRunTime, NextRunTime, Status -AutoSize
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
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

function Initialize-EasitManagementFramework {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",
        [Parameter()]
        [string] $ConfigURL = 'https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/configurations/emfConfig.xml',
        [Parameter()]
        [string] $SchemaURL = 'https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/schemas/emfConfig.xsd',
        [Parameter()]
        [string] $ConfigName = 'emfConfig.xml',
        [Parameter()]
        [string] $SchemaName = 'emfConfig.xsd'
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized!"
    }
    
    process {
        if (!(Test-Path -Path $EMFHome)) {
            try {
                $null = New-Item -Path "$Home" -Name 'EMF' -ItemType Directory
                Write-Verbose -Message "Created directory EMF in $Home"
            } catch {
                throw $_
            }
        } else {
            Write-Verbose "Found $EMFHome"
        }
        try {
            $wc = New-Object System.Net.WebClient
            Write-Verbose "Created WebClient"
        } catch {
            throw $_
        }
        Write-Output "Downloading assets..."
        try {
            $output1 = Join-Path -Path "$EMFHome" -ChildPath "$ConfigName"
            $wc.DownloadFile($ConfigURL, $output1)
            Write-Verbose "Download of $ConfigName complete"
        } catch {
            throw $_
        }
        try {
            $output2 = Join-Path -Path "$EMFHome" -ChildPath "$SchemaName"
            $wc.DownloadFile($SchemaURL, $output2)
            Write-Verbose "Download of $SchemaName complete"
        } catch {
            throw $_
        }
        Write-Output "Download of assets complete"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",
        
        [Parameter()]
        [Alias('file','filename')]
        [string] $ConfigurationFileName = 'emfConfig.xml',
        
        [Parameter(Mandatory)]
        [ValidateSet("Prod","Test","Dev","IntegrationProd","IntegrationTest","IntegrationDev")]
        [Alias('ConfigName')]
        [string] $ConfigurationName,

        [Parameter(Mandatory)]
        [Alias('ConfigSettings')]
        [hashtable] $ConfigurationSettings,

        [Parameter()]
        [switch ] $Validate,

        [Parameter()]
        [string] $SchemaFile = "$EMFHome\emfConfig.xsd"
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
    Write-Verbose "Process block start!"
        $emfConfigFilePath = "$EMFHome\$ConfigurationFileName"
        if (Test-Path "$emfConfigFilePath") {
            Write-Verbose -Message "$emfConfigFilePath already exists."
            try {
                Get-EMFConfig -EMFHome $EMFHome -ConfigurationFileName $ConfigurationFileName -ConfigurationName $ConfigurationName
                Write-Warning "A configuration with the name $ConfigurationName does already exist in $emfConfigFilePath. Use Set-EMFConfig to update configuration!"
                break
            } catch {
                Write-Verbose "No configuration with name $ConfigurationName found"
            }
        } else {
            Write-Verbose "$emfConfigFilePath does not exist."
            if (!(Test-Path -Path $EMFHome)) {
                New-Item -Path "$Home" -Name 'EMF' -ItemType Directory
                Write-Verbose -Message "Created directory EMF in $Home"
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
            Write-Verbose "Creating xml element for $ConfigurationName"
            $configObjectItem = $configObject.CreateElement("$ConfigurationName")
            $configObjectItems.AppendChild($configObjectItem) | Out-Null
        } catch {
            Write-Verbose "Failed to create xml element for $ConfigurationName"
            throw $_
        }
        foreach ($setting in $ConfigurationSettings.GetEnumerator()) {
            $settingName = $setting.Name
            $settingValue = $setting.Value
            if (!($settingName -eq 'ConfigurationName')) {
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
                Write-Verbose "SettingName = ConfigurationName"
            }
        }

        if ($Validate) {
            $emfConfigFilePathTemp = "$EMFHome\temp.xml"
            $configObject.Save("$emfConfigFilePathTemp")
            try {
                Test-EMFXMLData -Path $emfConfigFilePathTemp -SchemaFile $SchemaFile
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

function Set-EasitEmailRequestMailboxSetting {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter()]
        [string] $EmfConfigurationName = 'Prod',

        [Parameter()]
        [string] $EmailRequestConfigurationFilename = 'config.xml',

        [Parameter(Mandatory)]
        [Alias('Mailbox')]
        [string] $MailboxName,

        [Parameter(Mandatory)]
        [Alias('Name')]
        [string] $SettingName,

        [Parameter(Mandatory)]
        [Alias('Value')]
        [string] $SettingValue
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        try {
            $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            Write-Verbose "Found EMF Config"
        } catch {
            throw $_
        }
    }
    
    process {
        try {
            $erXmlConfigFile = Get-ChildItem -Path "$($emfConfig.EmailRequestRoot)" -Include "$EmailRequestConfigurationFilename" -Recurse -Force
            Write-Verbose "Found ER config."
        } catch {
            throw $_
        }
        try {
            $erConfig = Import-EMFXMLData -Path "$($erXmlConfigFile.FullName)"
            Write-Verbose "Imported configuration"
        } catch {
            throw $_
        }
        try {
            $node = $erConfig.SelectNodes("//properties/property") | Where-Object {$_.name -eq "displayName"} | Where-Object {$_.value -eq "$MailboxName"}
        } catch {
            throw $_
        }
        try {
            $mailBoxNode = $node.ParentNode.ParentNode
            Write-Verbose "Found mailbox in configuration"
        } catch {
            throw $_
        }
        try {
            $settingNode = $mailBoxNode.properties.property | Where-Object {$_.name -eq "$SettingName"}
        } catch {
            throw $_
        }
        try {
            $settingNode.Value = "$SettingValue"
            Write-Verbose "Updated value for $SettingName"
        } catch {
            throw $_
        }
        try {
            $erConfig.Save("$($emfConfig.EmailRequestRoot)\${EmfConfigurationFileName}")
            Write-Verbose "Saved EmailRequest configuration"
        } catch {
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
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
        [string] $EasitRoot = 'D:\Easit',

        [Parameter(ParameterSetName='Manual')]
        [string] $SystemRoot = "$EasitRoot\Systems\$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $ServiceName = "Easit$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $TomcatRoot = "$EasitRoot\Tomcat\$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [string] $BackupRoot = "$EasitRoot\_Backup\$ConfigurationName",

        [Parameter(ParameterSetName='Manual')]
        [Alias('ER','EmailRequest','erRoot')]
        [string] $EmailRequestRoot = "$EasitRoot\EmailRequest",

        [Parameter(ParameterSetName='Manual')]
        [Alias('IC','ImportClient','icRoot')]
        [string] $ImportClientRoot = "$EasitRoot\ImportClient",

        [Parameter(Mandatory,ParameterSetName='Array')]
        [string[]] $PropertySetting
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
    Write-Verbose "Process block start"
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
                ConfigurationName = "$ConfigurationName"
                EasitRoot = "$EasitRoot"
                SystemRoot = "$SystemRoot"
                ServiceName = "$ServiceName"
                TomcatRoot = "$TomcatRoot"
                BackupRoot = "$BackupRoot"
                EmailRequestRoot = "$EmailRequestRoot"
                ImportClientRoot = "$ImportClientRoot"
            }
            Write-Verbose "Created hashtable with settings"
        } else {
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
            throw $_
        }
        $configurationSettings.GetEnumerator() | ForEach-Object {
            $settingName = "$($_.Key)"
            $settingValue = "$($_.Value)"
            $currentConfigurationFile.systems.${ConfigurationName}.${settingName} = $settingValue
        }            
        try {
            $currentConfigurationFile.Save("$EMFHome\$ConfigurationFileName")
        } catch {
            Write-Verbose "Something went wrong while updating configuration file ($ConfigurationFileName), block $ConfigurationName"
            throw $_
        }
        Write-Verbose "Process block end"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}

function Start-EasitGOApplication {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter()]
        [string] $EmfConfigurationName = 'Prod',

        [Parameter()]
        [switch] $Verify
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        try {
            $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            Write-Verbose "Found EMF Config"
            $easitGoServiceName = "$($emfConfig.ServiceName)"
            Write-Verbose "ServiceName is $($emfConfig.ServiceName)"
        } catch {
            throw $_
        }
    }
    
    process {
        $tomcatConf = Join-Path -Path "$($emfConfig.TomcatRoot)" -ChildPath 'conf'
        $tomcatServerXMLPath = Join-Path -Path "$tomcatConf" -ChildPath 'server.xml'
        $tomcatServerXML = Import-EMFXMLData -Path "$tomcatServerXMLPath"
        $tomcatServerPort = "$($tomcatServerXML.Server.Port)"
        try {
            $easitGoService = Get-CimInstance -ClassName Win32_Service -Filter "Name Like '$easitGoServiceName'"
        } catch {
            throw $_
        }
        if ($null -eq $easitGoService) {
            throw "Unable to find service with name like $easitGoServiceName"
        } else {
            Write-Verbose "Successfully got CimInstance for $systemName"
        }
        Write-Verbose "Starting easitGoService...."
        try {
            Invoke-CimMethod -InputObject $easitGoService -MethodName StartService | Out-Null
            $waitingTime = 0
            do {
                Write-CustomLog -Message "Waiting for easitGoService to receive state 'Running'" -Level INFO
                Start-Sleep -Seconds 15
                $waitingTime += 15
                $systemToStart = Get-CimInstance -InputObject $easitGoService
            } while ($systemToStart.State -ne 'Running' -AND $waitingTime -le 240)
            if ($waitingTime -gt 240) {
                Write-Warning 'Time to start easitGoService exceeded 2 minutes, sending error!'
                continue
            }
        } catch {
            throw $_
        }
        Write-Verbose -Message "easitGoService started and running!"
        if ($Verify) {
            try {
                $url = "http://localhost:${$tomcatServerPort}/monitor/?type=alive"
                Write-Verbose "Checking if application is alive"
                $systemStatus = Invoke-WebRequest -Uri "$url" -UseBasicParsing -ErrorAction Stop
            } catch {
                throw $_
            }
            if ($systemStatus.StatusCode -eq 200) {
                Write-Output "Application is up and running!"
            } else {
                Write-Error "easitGoService is started but the application in not reachable!"
            }
        }
        return $systemToStart
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Stop-EasitGOApplication {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',

        [Parameter()]
        [string] $EmfConfigurationName = 'Prod'
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        try {
            $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            Write-Verbose "Found EMF Config"
            $easitGoServiceName = "$($emfConfig.ServiceName)"
            Write-Verbose "ServiceName is $($emfConfig.ServiceName)"
        } catch {
            throw $_
        }
    }
    
    process {
        try {
            $easitGoService = Get-CimInstance -ClassName Win32_Service -Filter "Name Like '$easitGoServiceName'"
        } catch {
            throw $_
        }
        if ($null -eq $easitGoService) {
            throw "Unable to find service with name like $easitGoServiceName"
        } else {
            Write-Verbose "Successfully got CimInstance for $systemName"
        }
        Write-Verbose "Stopping easitGoService...."
    try {
        Invoke-CimMethod -InputObject $easitGoService -MethodName StopService | Out-Null
        Start-Sleep -Seconds 15
        do {
            Write-Verbose "Waiting for easitGoService to stop"
            Start-Sleep -Seconds 15
            $systemToStop = Get-CimInstance -InputObject $easitGoService
        } while (!($systemToStop.State -eq 'Stopped'))
    } catch {
        throw $_
    }
    Write-Verbose "easitGoService stopped"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Test-EMFXMLData {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",

        [Parameter()]
        [string] $Path = "$EMFHome\emfConfig.xml",

        [Parameter()]
        [string] $SchemaFile = "$EMFHome\emfConfig.xsd"
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        Write-Verbose "Process block start"
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
        Write-Verbose "Process block end"
    }
    
    end {
        $schemaReader.Close()
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}

function Convert-EasitLogEntryToPsObject {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Convert-EasitLogEntryToPsObject.md")]
    param (
        [Parameter(ValueFromPipeline)]
        [string] $String
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        Write-Verbose "Selecting strings from entry"
        $stringDate = Select-String -InputObject $String -Pattern '\d{4}-\d{2}-\d{2}'
        $stringDate = "$($stringDate.Matches.Value)"
        Write-Debug "stringDate = $stringDate"

        $stringTime = Select-String -InputObject $String -Pattern '\d{2}:\d{2}:\d{2}\.\d{3}'
        $stringTime = "$($stringTime.Matches.Value)"
        Write-Debug "stringTime = $stringTime"

        $stringLevel = Select-String -InputObject $String -Pattern 'FATAL|ERROR|WARN|INFO|DEBUG|TRACE'
        $stringLevel = "$($stringLevel.Matches.Value)"
        Write-Debug "stringLevel = $stringLevel"

        $stringMessage = Select-String -InputObject $String -Pattern '- .+\['
        $stringMessage = "$($stringMessage.Matches.Value)"
        $stringMessage = $stringMessage.TrimStart('- ')
        $stringMessage = $stringMessage.TrimEnd('[')
        Write-Debug "stringMessage = $stringMessage"

        $stringClass = Select-String -InputObject $String -Pattern '\[.+\]'
        $stringClass = "$($stringClass.Matches.Value)"
        $stringClass = $stringClass.TrimStart('[')
        $stringClass = $stringClass.TrimEnd(']')
        Write-Debug "stringClass = $stringClass"

        $stringStack = Select-String -InputObject $String -Pattern '\- [\w|\W|\n\r]*'
        $stringStack = "$($stringStack.Matches.Value)"
        $stringStack = $stringStack.TrimStart("- $stringMessage [$stringClass]")
        $stringStack = $stringStack.TrimStart()
        Write-Debug "stringStack = $stringStack"
        Write-Verbose "Creating object from entry strings"
        $returnObject = [PSCustomObject]@{
            Date                = "$stringDate"
            Time                = "$stringTime"
            Level               = "$stringLevel"
            Class               = "$stringClass"
            Message             = "$stringMessage"
            FullStackMessage    = "$stringStack"
        }
        Write-Verbose "Returning entry as object"
        return $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
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

