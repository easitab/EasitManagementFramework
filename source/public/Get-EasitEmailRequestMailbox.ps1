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
        [string[]] $EmailRequestConfigurationFilename = '*config*.xml',

        [Parameter()]
        [Alias('Mailbox')]
        [string[]] $MailboxName
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
        $erXmlConfigFiles = @()
        foreach ($xmlConfigFilenames in $EmailRequestConfigurationFilename) {
            try {
                $erXmlConfigFiles += Get-ChildItem -Path "$($emfConfig.EmailRequestRoot)" -Include "$xmlConfigFilenames" -Recurse -Force
            } catch {
                throw $_
            }
        }
        foreach ($erXmlConfigFile in $erXmlConfigFiles) {
            if ($MailboxName) {
                foreach ($Mailbox in $MailboxName) {
                    if ($Mailbox -match '\*') {
                        try {
                            Convert-EmailRequestConfigfile $erXmlConfigFile | Where-Object {$_.displayName -Like "$Mailbox"}
                        } catch {
                            throw $_
                        }
                    } else {
                        try {
                            Convert-EmailRequestConfigfile $erXmlConfigFile | Where-Object {$_.displayName -eq "$Mailbox"}
                        } catch {
                            throw $_
                        }
                    }
                }
            } else {
                try {
                    Convert-EmailRequestConfigfile $erXmlConfigFile
                } catch {
                    throw $_
                }
            }
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}