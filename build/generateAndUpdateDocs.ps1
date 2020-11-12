# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$sourceRoot = "$projectRoot\source"
$tempModuleFileName = 'EasitManagementFramework'
# Runtime variables
Set-Location -Path $projectRoot
$privScripts = Get-ChildItem -Path "$sourceRoot\private" -Filter "*.ps1" -Recurse
$pubScripts = Get-ChildItem -Path "$sourceRoot\public" -Filter "*.ps1" -Recurse
$docsRoot = "$projectRoot/docs"
$allscripts = @()
$allscripts += $privScripts
$allscripts += $pubScripts
try {
    Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
    Import-Module platyPS -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
try {
    Import-Module -Name "$projectRoot\${tempModuleFileName}" -Force -Verbose -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
foreach ($script in $allscripts) {
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