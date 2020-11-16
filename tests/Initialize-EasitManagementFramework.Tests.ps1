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
    It 'EMFHome should have a default value' {
        Get-Command "$commandName" | Should -HaveParameter EMFHome -DefaultValue '$Home\EMF'
    }
    It 'ConfigURL should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigURL -Not -Mandatory
    }
    It 'ConfigURL should have a default value' {
        Get-Command "$commandName" | Should -HaveParameter ConfigURL -DefaultValue 'https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/configurations/emfConfig.xml'
    }
    It 'SchemaURL should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter SchemaURL -Not -Mandatory
    }
    It 'SchemaURL should have a default value' {
        Get-Command "$commandName" | Should -HaveParameter SchemaURL -DefaultValue 'https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/schemas/emfConfig.xsd'
    }
    It 'ConfigName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter ConfigName -Not -Mandatory
    }
    It 'ConfigName have a default value' {
        Get-Command "$commandName" | Should -HaveParameter ConfigName -DefaultValue 'emfConfig.xml'
    }
    It 'SchemaName should not be mandatory' {
        Get-Command "$commandName" | Should -HaveParameter SchemaName -Not -Mandatory
    }
    It 'SchemaName have a default value' {
        Get-Command "$commandName" | Should -HaveParameter SchemaName -DefaultValue 'emfConfig.xsd'
    }
}