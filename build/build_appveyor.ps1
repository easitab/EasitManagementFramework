# This file in it self is not used but only a template.
# Actual code that will be executed lives in appveyor.yml

New-Module -Name "$env:moduleName" -ScriptBlock {
    $modulePath = "$env:moduleRoot\$env:moduleName.psm1"
    $privScripts = Get-ChildItem -Path "$env:sourceRoot\private" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$env:sourceRoot\public" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        $newModuleDir = New-Item -Path "$env:resourceRoot" -Name "module" -ItemType 'directory' -Force
        $newModuleFile = New-Item -Path "$env:moduleRoot" -Name "$env:moduleName.psm1" -ItemType "file"
    }
    foreach ($privateScript in $privScripts) {
        $scriptContent = Get-Content -Path "$($privateScript.FullName)" -Raw
        if (Test-Path -Path $modulePath) {
            Add-Content -Path $modulePath -Value $scriptContent
        } else {
            Write-Output "Unable to find modulePath at $modulePath" -ForegroundColor Red
        }
    }
    foreach ($publicScript in $pubScripts) {
        $scriptContent = Get-Content -Path "$($publicScript.FullName)" -Raw
        if (Test-Path -Path $modulePath) {   
            Add-Content -Path $modulePath -Value $scriptContent                     
            Add-Content -Path $modulePath -Value "Export-ModuleMember -Function $($publicScript.BaseName)"
        } else {
            Write-Output "Unable to find modulePath at $modulePath" -ForegroundColor Red
        }
    }
}
$manifest = @{
    Path              = "$env:moduleRoot\$env:moduleName.psd1" 
    RootModule        = "$env:moduleName.psm1" 
    CompanyName       = "$env:companyName"
    Author            = "$env:moduleAuthor"
    ModuleVersion     = "$env:APPVEYOR_BUILD_VERSION"
    HelpInfoUri       = "$env:helpInfoUri"
    LicenseUri        = "$env:licenseUri"
    ProjectUri        = "$env:projectUri"
    Description       = 'Management Framework for Easit BPS and Easit GO'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2020 $env:companyName. All rights reserved."
}
New-ModuleManifest @manifest
Get-ChildItem -Path "$env:moduleRoot"