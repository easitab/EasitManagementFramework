try {
        Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module platyPS -Scope Global -Force -ErrorAction Stop
} catch {
        Write-Error $_ 
}
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
Write-Output "Project root: $projectRoot"
Set-Location -Path $projectRoot
Write-Output "Working in $projectRoot"
$privScripts = Get-ChildItem -Path "$projectRoot\src\priv" -Filter "*.ps1" -Recurse
$pubScripts = Get-ChildItem -Path "$projectRoot\src\pub" -Filter "*.ps1" -Recurse
$docsRoot = "$projectRoot\docs"
$allscripts = @()
$allscripts += $privScripts
$allscripts += $pubScripts

foreach ($script in $allscripts) {
        $commandName = $script.BaseName
        Write-Output "Script path: $($script.FullName)"
        try {
            Import-Module "$($script.FullName)" -Scope Global -Force -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
        Write-Output "Imported $commandName"
        if (Test-Path -Path "$docsRoot/${commandName}.md") {
            Write-Output "Found $docsRoot/${commandName}.md"
            try {
                Import-Module "$($script.FullName)" -Scope Global -Force -ErrorAction Stop
                Update-MarkdownHelp -Path "$docsRoot/${commandName}.md" -OutputFolder "$docsRoot" -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        } else {
            Write-Output "Unable to find $docsRoot/${commandName}.md"
            try {
                Import-Module "$($script.FullName)" -Scope Global -Force -ErrorAction Stop
                New-MarkdownHelp -Command $commandName -OutputFolder "$docsRoot" -AlphabeticParamsOrder -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        }
        Write-Output "MarkdownHelp done"
}
try {
    New-ExternalHelp -Path "$docsRoot" -OutputPath "$docsRoot\en-US\" -ErrorAction Stop
} catch {
    Write-Error $_
}
Write-Output "New-ExternalHelp done!"
