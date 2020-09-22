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

New-Module -Name "$env:moduleName" -ScriptBlock {
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
    if (!(Test-Path -Path $tempModulePath)) {
        $tempModuleFile = New-Item -Path "$projectRoot" -Name "${tempModuleFileName}.psm1" -ItemType "file"
        Write-Output "Created $newModuleFile"
    }
    foreach ($script in $allscripts) {
        $exportFunction = "Export-ModuleMember -Function $($script.BaseName)"
        $scriptContent = Get-Content -Path "$($script.FullName)" -Raw
        if (Test-Path -Path $tempModulePath) {    
            try {
                Add-Content -Path $tempModulePath -Value $scriptContent -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
            try {
                Add-Content -Path $tempModulePath -Value $exportFunction -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        }
    }
}

$manifest = @{
    Path              = "$projectRoot\${tempModuleFileName}.psd1" 
    RootModule        = "$tempModuleFileName.psm1" 
    CompanyName       = "$env:companyName"
    Author            = "$env:moduleAuthor"
    ModuleVersion     = "$env:APPVEYOR_BUILD_VERSION"
    HelpInfoUri       = "$env:projectUri/tree/development/docs"
    LicenseUri        = "$env:projectUri/blob/development/LICENSE"
    ProjectUri        = "$env:projectUri"
    Description       = 'Management Framework for Easit BPS and Easit GO'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2020 $env:companyName. All rights reserved."
}
New-ModuleManifest @manifest | Out-Null

try {
        Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module platyPS -Force -ErrorAction Stop
} catch {
        Write-Error $_ 
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