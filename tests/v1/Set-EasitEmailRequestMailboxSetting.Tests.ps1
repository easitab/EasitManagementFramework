Describe 'Parameters' {
    BeforeAll {
        $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
        $codeFileName = Split-Path -Path $testFilePath -Leaf
        $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
        $testRoot = Split-Path -Path $PSCommandPath -Parent
        $projectRoot = Split-Path -Path $testRoot -Parent
        $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath "source"
        $codeFile = Get-ChildItem -Path "$sourceRoot" -Include "$codeFileName" -Recurse
        if (Test-Path $codeFile) {
            . $codeFile
        } else {
            Write-Host "Unable to locate code file to test against!!" -ForegroundColor Red
        }
        
    }
    It 'EmfHome should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfHome -Not -Mandatory
    }
    It 'EmfHome should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfHome -DefaultValue '${env:ALLUSERSPROFILE}\EMF'
    }
    It 'EmfConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationFileName -Not -Mandatory
    }
    It 'EmfConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationFileName -DefaultValue 'emfConfig.xml'
    }
    It 'EmfConfigurationName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationName -Not -Mandatory
    }
    It 'EmfConfigurationName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationName -DefaultValue 'Prod'
    }
    It 'MailboxName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter MailboxName -Mandatory
    }
    It 'SettingName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter SettingName -Mandatory
    }
    It 'SettingValue should have a value' {
        Get-Command "$commandName" | Should -HaveParameter SettingValue -Mandatory
    }
}
