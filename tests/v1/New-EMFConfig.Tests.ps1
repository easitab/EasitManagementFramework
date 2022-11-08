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
    It 'EMFHome should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -Not -Mandatory
    }
    It 'EMFHome should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -DefaultValue '${env:ALLUSERSPROFILE}\EMF'
    }
    It 'EmfConfigurationFileName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationFileName -Not -Mandatory
    }
    It 'EmfConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationFileName -DefaultValue 'emfConfig.xml'
    }
    It 'EmfConfigurationName should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationName -Mandatory
    }
    It 'EmfConfigurationName should be null' {
        $ConfigurationName | Should -BeNullOrEmpty
    }
    It 'EmfConfigurationSettings should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationSettings -Mandatory
    }
    It 'EmfConfigurationSettings should be a hashtable' {
        $ConfigSettings = @{}
        $ConfigSettings | Should -BeOfType [System.Collections.Hashtable]
    }
    It 'ConfigSettings should be null' {
        $ConfigSettings = @{}
        $ConfigSettings | Should -BeNullOrEmpty
    }
    It 'Validate should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter Validate -Not -Mandatory
    }
    It 'Validate should be a switch' {
        [switch]$Validate = $false
        $Validate | Should -BeOfType [System.Management.Automation.SwitchParameter]
    }
}
