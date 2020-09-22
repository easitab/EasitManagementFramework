try {
        Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
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
$docsRoot = "$projectRoot/docs"
$allscripts = @()
$allscripts += $privScripts
$allscripts += $pubScripts
$tempModuleFileName = 'MyModule'
$tempModulePath = "$projectRoot/${tempModuleFileName}.psm1"
try {
    New-Item -Path $projectRoot -ItemType File -Name $tempModuleFileName -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
foreach ($script in $allscripts) {
        $exportFunction = "Export-ModuleMember -Function $($script.BaseName)"
        $scriptContent = Get-Content -Path "$($script.FullName)" -Raw
        if (Test-Path -Path $tempModulePath) {    
            Add-Content -Path $tempModulePath -Value $scriptContent        
            Add-Content -Path $tempModulePath -Value $exportFunction
        }
        Write-Output "Temp module file done"
}
try {
    Import-Module -Name "$projectRoot" -Force -Verbose
} catch {
    Write-Error $_
    break
}
foreach ($script in $allscripts) {
    $commandName = $script.BaseName
    if (Test-Path -Path "$docsRoot/${commandName}.md") {
        Write-Output "Found $docsRoot/${commandName}.md"
        try {
            Update-MarkdownHelp -Path "$docsRoot/${commandName}.md" -OutputFolder "$docsRoot" -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
    } else {
        Write-Output "Unable to find $docsRoot/${commandName}.md"
        try {
            New-MarkdownHelp -Command $commandName -OutputFolder "$docsRoot" -AlphabeticParamsOrder -ErrorAction Stop
        } catch {
            Write-Error $_
            break
        }
    }
}
try {
    New-ExternalHelp -Path "$docsRoot" -OutputPath "$docsRoot\en-US\" -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
Write-Output "New-ExternalHelp done!"
Remove-Item $tempModulePath -Force