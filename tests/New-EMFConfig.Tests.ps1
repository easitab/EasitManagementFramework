Describe 'Parameters' {
    BeforeAll {
        $codeFile = $PSCommandPath.Replace('.Tests.ps1','.ps1')
        if (Test-Path $codeFile.Replace('tests\','source\private\')) {
            $codeFilePath = $codeFile.Replace('tests\','source\private\')
            . $codeFilePath
        } elseif (Test-Path $codeFile.Replace('tests\','source\public\')) {
            $codeFilePath = $codeFile.Replace('tests\','source\public\')
            . $codeFilePath
        } else {
            Write-Host "Unable to locate code file to test against!" -ForegroundColor Red
        }
        $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
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
        Get-Command "$commandName" | Should -HaveParameter ConfigurationFileName -DefaultValue 'config.xml'
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
