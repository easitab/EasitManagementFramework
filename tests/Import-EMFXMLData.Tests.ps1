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
    It 'Path should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter Path -Mandatory
    }
    It 'Validate should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter Validate -Not -Mandatory
    }
    It 'Validate should be a switch' {
        Get-Command "$commandName" | Should -HaveParameter Validate -Type Switch
    }    
}