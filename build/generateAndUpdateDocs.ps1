# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$sourceRoot = Join-Path -Path "$projectRoot" -ChildPath 'source'
$tempModuleFileName = 'EasitManagementFramework'
$docsRoot = Join-Path -Path "$projectRoot" -ChildPath 'docs'
$tempModuleRoot = Join-Path -Path "$projectRoot" -ChildPath "$tempModuleFileName"
Set-Location -Path $projectRoot
# Runtime variables

$allScripts = Get-ChildItem -Path "$sourceRoot" -Filter "*.ps1" -Recurse
try {
    Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
    Import-Module platyPS -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
try {
    Import-Module -Name "$tempModuleRoot" -Force -Verbose -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
foreach ($script in $allScripts) {
    $commandName = $script.BaseName
    if (Test-Path -Path "$docsRoot/${commandName}.md") {
        Write-Output "Found $docsRoot/${commandName}.md"
        try {
            Update-MarkdownHelp -Path "$docsRoot/${commandName}.md" -AlphabeticParamsOrder -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
    } else {
        Write-Output "Unable to find $docsRoot/${commandName}.md"
        try {
            New-MarkdownHelp -Command $commandName -OutputFolder "$docsRoot" -AlphabeticParamsOrder -OnlineVersionUrl "https://github.com/easitab/EasitManagementFramework/blob/development/docs/${commandName}.md" -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
    }
    New-MarkdownHelp -Command $commandName -OutputFolder "$docsRoot" -AlphabeticParamsOrder -OnlineVersionUrl "https://github.com/easitab/EasitManagementFramework/blob/development/docs/${commandName}.md" -ErrorAction Stop
}
Write-Verbose "Done updating MarkdownHelp"
Write-Verbose "Generating new external help"
try {
    New-ExternalHelp -Path "$docsRoot" -OutputPath "$docsRoot\en-US" -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
Write-Output "New-ExternalHelp done!"