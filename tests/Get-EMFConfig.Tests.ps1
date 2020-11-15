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
}
