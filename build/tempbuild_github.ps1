# Runtime variables
$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$sourceRoot = "$projectRoot\source"
$tempModuleFileName = 'EasitManagementFramework'
$tempModuleRoot = "$projectRoot/$tempModuleFileName"
$tempModulePath = "$tempModuleRoot/${tempModuleFileName}.psm1"
# Runtime variables
Set-Location -Path $projectRoot
$privScripts = Get-ChildItem -Path "$sourceRoot\private" -Filter "*.ps1" -Recurse
$pubScripts = Get-ChildItem -Path "$sourceRoot\public" -Filter "*.ps1" -Recurse
$allscripts = @()
$allscripts += $privScripts
$allscripts += $pubScripts
Write-Output "New module start"
New-Module -Name "$tempModuleFileName" -ScriptBlock {
    $projectRoot = Split-Path -Path $PSScriptRoot -Parent
    Set-Location -Path $projectRoot
    $privScripts = Get-ChildItem -Path "$sourceRoot\private" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$sourceRoot\public" -Filter "*.ps1" -Recurse
    $allscripts = @()
    $allscripts += $privScripts
    $allscripts += $pubScripts
    $tempModuleFileName = 'EasitManagementFramework'
    $tempModuleRoot = "$projectRoot/$tempModuleFileName"
    $tempModulePath = "$tempModuleRoot/${tempModuleFileName}.psm1"
    if (!(Test-Path -Path $tempModuleRoot)) {
        New-Item -Path "$projectRoot" -Name "$tempModuleFileName" -ItemType "directory" | Out-Null
        Write-Output "Created $tempModuleRoot"
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
$projectUriRoot = 'https://github.com/easitab/EasitManagementFramework'
$manifest = @{
    Path              = "$tempModuleRoot/${tempModuleFileName}.psd1" 
    RootModule        = "$tempModuleRoot/${tempModuleFileName}.psm1" 
    CompanyName       = "Easit AB"
    Author            = "Anders Thyrsson"
    ModuleVersion     = "0.0.1"
    HelpInfoUri       = "$projectUriRoot/tree/development/docs"
    LicenseUri        = "$projectUriRoot/blob/development/LICENSE"
    ProjectUri        = "$projectUriRoot"
    Description       = 'Management Framework for Easit BPS and Easit GO'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2020 Easit AB. All rights reserved."
}
New-ModuleManifest @manifest