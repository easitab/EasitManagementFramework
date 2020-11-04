function Set-EasitEmailRequestMailboxSetting {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        
        [Parameter()]
        [string] $EmfConfigurationFileName = 'config.xml',

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
            Write-Verbose "Found EMF Config, yay"
        } catch {
            throw $_
        }
    }
    
    process {
        try {
            $erXmlConfigFile = Get-ChildItem -Path "$($emfConfig.EmailRequestRoot)" -Include "$EmailRequestConfigurationFilename" -Recurse -Force
            Write-Verbose "Found ER config"
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