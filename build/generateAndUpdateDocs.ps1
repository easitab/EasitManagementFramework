$projectRoot = Split-Path -Path $PSScriptRoot -Parent
Write-Output "Project root: $projectRoot"
Set-Location -Path $projectRoot
Write-Output "Working in $projectRoot"
$privScripts = Get-ChildItem -Path "$projectRoot\src\priv" -Filter "*.ps1" -Recurse
$pubScripts = Get-ChildItem -Path "$projectRoot\src\pub" -Filter "*.ps1" -Recurse
$docsRoot = "$projectRoot\docs"
break
foreach ($script in $privScripts + $pubScripts) {
        $commandName = $script.BaseName
        . $script.FullName
        if (Test-Path -Path "$docsRoot\${commandName}.md") {
            try {
                Update-MarkdownHelp -Path "$($script.FullName)" -OutputFolder "$docsRoot"
            } catch {
                Write-Output $_
                break
            }
        } else {
            try {
                New-MarkdownHelp -Command "$commandName" -OutputFolder "$docsRoot"
            } catch {
                Write-Output $_
                break
            }
        }
        if (Test-Path -Path "$docsRoot\${commandName}.md") {
            New-ExternalHelp -Path "$docsRoot" -OutputPath "$docsRoot\en-US\"
        } else {
            Write-Output "Unable to find $docsRoot\${commandName}.md"
        }
}