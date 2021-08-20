function Get-EasitEmailRequestMailbox {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $EmfHome = "${env:ALLUSERSPROFILE}\EMF",
        
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