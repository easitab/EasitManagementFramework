try {
        Install-Module -Name platyPS -Scope Global -Force -ErrorAction Stop
        Import-Module platyPS -Force -ErrorAction Stop
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
            . "$($script.FullName)"
        } catch {
            Write-Error $_
            break
        }
        Write-Output "Imported $commandName"
        if (Test-Path -Path "$docsRoot/${commandName}.md") {
            Write-Output "Found $docsRoot/${commandName}.md"
            try {
                Update-MarkdownHelp -Path "$($script.FullName)" -OutputFolder "$docsRoot" -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        } else {
            Write-Output "Unable to find $docsRoot/${commandName}.md"
            try {
                New-MarkdownHelp -Command $commandName -OutputFolder "$docsRoot" -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        }
        Write-Output "MarkdownHelp done"
        if (Test-Path -Path "$docsRoot/${commandName}.md") {
            Write-Output "Found $docsRoot/${commandName}.md"
            New-ExternalHelp -Path "$docsRoot" -OutputPath "$docsRoot\en-US\" -ErrorAction Stop
        } else {
            Write-Output "Unable to find $docsRoot/${commandName}.md"
        }
        Write-Output "New-ExternalHelp done!"
}
