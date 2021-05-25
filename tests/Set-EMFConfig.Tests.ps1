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
        Get-Command "$commandName" | Should -HaveParameter EMFHome -DefaultValue '$Home\EMF'
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
        $EmfConfigurationName | Should -BeNullOrEmpty
    }
    It 'PropertySetting should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter PropertySetting -Mandatory
    }
    It 'ValidateSettings should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ValidateSettings -Not -Mandatory
    }
    It 'ValidateSettings should be a switch' {
        [switch]$ValidateSettings = $false
        $ValidateSettings | Should -BeOfType [System.Management.Automation.SwitchParameter]
    }
}