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
            Write-Host "Unable to locate code file to test against!" -ForegroundColor Red
        }
        
    }
    It 'ConfigurationFileName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfHome -Not -Mandatory
    }
    It 'ConfigurationFileName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EmfHome -DefaultValue '$Home\EMF'
    }
    It 'ConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationFileName -Not -Mandatory
    }
    It 'ConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationFileName -DefaultValue 'emfConfig.xml'
    }
    It 'ConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationName -Not -Mandatory
    }
    It 'ConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EmfConfigurationName -DefaultValue 'Dev'
    }
    It 'RunningElevated should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter RunningElevated -Not -Mandatory
    }
}
