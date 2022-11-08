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
    It 'InputObject should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter InputObject -Not -Mandatory
    }
    It 'TaskName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter TaskName -Not -Mandatory
    }
    It 'AsJob should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigurationName -Not -Mandatory
    }
    It 'AsJob should be a switch' {
        Get-Command "$commandName" | Should -HaveParameter AsJob -Type Switch
    }    
}