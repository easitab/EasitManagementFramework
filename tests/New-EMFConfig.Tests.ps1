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
    It 'EMFHome should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -Not -Mandatory
    }
    It 'EMFHome should have a value' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -DefaultValue '$Home\EMF'
    }
    It 'ConfigurationFileName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationFileName -Not -Mandatory
    }
    It 'ConfigurationFileName should have a value' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationFileName -DefaultValue 'emfConfig.xml'
    }
    It 'ConfigurationName should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationName -Mandatory
    }
    It 'ConfigurationName should be null' {
        $ConfigurationName | Should -BeNullOrEmpty
    }
    It 'ConfigurationSettings should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationSettings -Mandatory
    }
    It 'ConfigurationSettings should be a hashtable' {
        $ConfigSettings = @{}
        $ConfigSettings | Should -BeOfType [System.Collections.Hashtable]
    }
    It 'ConfigSettings should be null' {
        $ConfigSettings = @{}
        $ConfigSettings | Should -BeNullOrEmpty
    }
    It 'ValidateConfig should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ValidateConfig -Not -Mandatory
    }
    It 'ValidateConfig should be a switch' {
        [switch]$ValidateConfig = $false
        $ValidateConfig | Should -BeOfType [System.Management.Automation.SwitchParameter]
    }
}
