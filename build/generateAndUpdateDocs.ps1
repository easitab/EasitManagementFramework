$projectRoot = Split-Path -Path $PSScriptRoot -Parent
Write-Output "Project root: $projectRoot"
Set-Location -Path $projectRoot
Write-Output "Working in $pwd"
$privScripts = Get-ChildItem -Path "$projectRoot\src\priv" -Filter "*.ps1" -Recurse
$pubScripts = Get-ChildItem -Path "$projectRoot\src\pub" -Filter "*.ps1" -Recurse
$docsRoot = "$projectRoot/docs"
$allscripts = @()
$allscripts += $privScripts
$allscripts += $pubScripts
$tempModuleFileName = 'MyModule'
$tempModuleRoot = "$projectRoot/$tempModuleFileName"
$tempModulePath = "$tempModuleRoot/${tempModuleFileName}.psm1"
Write-Output "New module start"
New-Module -Name "$tempModuleFileName" -ScriptBlock {
    $projectRoot = Split-Path -Path $PSScriptRoot -Parent
    Set-Location -Path $projectRoot
    $privScripts = Get-ChildItem -Path "$projectRoot\src\priv" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$projectRoot\src\pub" -Filter "*.ps1" -Recurse
    $docsRoot = "$projectRoot/docs"
    $allscripts = @()
    $allscripts += $privScripts
    $allscripts += $pubScripts
    $tempModuleFileName = 'MyModule'
    $tempModuleRoot = "$projectRoot/$tempModuleFileName"
    $tempModulePath = "$tempModuleRoot/${tempModuleFileName}.psm1"
    if (!(Test-Path -Path $tempModulePath)) {
        New-Item -Path "$projectRoot" -Name "$tempModuleFileName" -ItemType "directory" | Out-Null
        Write-Output "Created $tempModulePath"
    }
    if (!(Test-Path -Path $tempModulePath)) {
        $tempModuleFile = New-Item -Path "$tempModuleRoot" -Name "${tempModuleFileName}.psm1" -ItemType "file"
        Write-Output "Created $newModuleFile"
    }
    foreach ($script in $allscripts) {
        $exportFunction = "Export-ModuleMember -Function $($script.BaseName)"
        $scriptContent = Get-Content -Path "$($script.FullName)" -Raw
        if (Test-Path -Path $tempModulePath) {    
            try {
                Add-Content -Path $tempModuleFile -Value $scriptContent -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
            try {
                Add-Content -Path $tempModuleFile -Value $exportFunction -ErrorAction Stop
            } catch {
                Write-Error $_
                break
            }
        }
    }
}
Write-Output "New module end"
$manifest = @{
    Path              = "$tempModuleRoot/${tempModuleFileName}.psd1" 
    RootModule        = "$tempModuleRoot/$tempModuleFileName.psm1" 
    CompanyName       = "Easit AB"
    Author            = "Anders Thyrsson"
    ModuleVersion     = "0.0.1"
    HelpInfoUri       = "https://github.com/easitab/EasitManagementFramework/tree/development/docs"
    LicenseUri        = "https://github.com/easitab/EasitManagementFramework/blob/development/LICENSE"
    ProjectUri        = "https://github.com/easitab/EasitManagementFramework"
    Description       = 'Management Framework for Easit BPS and Easit GO'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2020 Easit AB. All rights reserved."
}
New-ModuleManifest @manifest
Write-Output "New module manifest start"

try {
    Install-Module -Name platyPS -Scope CurrentUser -Force -ErrorAction Stop
    Import-Module platyPS -Force -ErrorAction Stop
} catch {
    Write-Error $_
    break
}
try {
    Import-Module -Name "$projectRoot\MyModule" -Force -Verbose -ErrorAction Stop
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
Remove-Item $tempModuleFile -Force -ErrorAction SilentlyContinue