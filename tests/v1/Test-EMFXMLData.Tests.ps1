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
    It 'EMFHome should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -Not -Mandatory
    }
    It 'EMFHome should be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -DefaultValue '${env:ALLUSERSPROFILE}\EMF'
    }
    It 'Path should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter Path -Not -Mandatory
    }
    It 'Path should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter Path -DefaultValue '$EMFHome\emfConfig.xml'
    }
    It 'SchemaFile should be a switch' {
        Get-Command "$commandName" | Should -HaveParameter SchemaFile -Not -Mandatory
    }
    It 'SchemaFile should be a switch' {
        Get-Command "$commandName" | Should -HaveParameter SchemaFile -DefaultValue '$EMFHome\emfConfig.xsd'
    }
}