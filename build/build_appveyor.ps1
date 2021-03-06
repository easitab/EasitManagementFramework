# This file in it self is not used but only a template.
# Actual code that will be executed lives in appveyor.yml

New-Module -Name "$env:moduleName" -ScriptBlock {
    $modulePath = Join-Path -Path "$env:moduleRoot" -ChildPath "$env:moduleName.psm1"
    $privScripts = Get-ChildItem -Path "$env:sourceRoot\private" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$env:sourceRoot\public" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        $newModuleDir = New-Item -Path "$env:resourceRoot" -Name "$env:moduleName" -ItemType 'directory' -Force
        $newModuleFile = New-Item -Path "$env:moduleRoot" -Name "$env:moduleName.psm1" -ItemType "file"
    }
    foreach ($privateScript in $privScripts) {
        $scriptContent = Get-Content -Path "$($privateScript.FullName)" -Raw
        if (Test-Path -Path $modulePath) {
            Add-Content -Path $modulePath -Value $scriptContent
        } else {
            Write-Output "Unable to find modulePath at $modulePath"
        }
    }
    foreach ($publicScript in $pubScripts) {
        $scriptContent = Get-Content -Path "$($publicScript.FullName)" -Raw
        if (Test-Path -Path $modulePath) {
            Add-Content -Path $modulePath -Value $scriptContent
            Add-Content -Path $modulePath -Value "Export-ModuleMember -Function $($publicScript.BaseName)"
        } else {
            Write-Output "Unable to find modulePath at $modulePath"
        }
    }
} | Out-Null

$moduleFilePath = Join-Path -Path "$env:moduleRoot" -ChildPath "${env:moduleName}.psm1"

if (Test-Path -Path "$moduleFilePath") {
    Write-Output "Check for moduleFilePath, OK!"
}

else {
    throw "Unable to find $moduleFilePath"
}

$manifestFilePath = Join-Path -Path "$env:moduleRoot" -ChildPath "${env:moduleName}.psd1"

$manifest = @{
    Path              = "$manifestFilePath"
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

New-ModuleManifest @manifest | Out-Null

if (Test-Path -Path "$manifestFilePath") {
    Write-Output "Check for manifestFilePath, OK!"
} else {
    throw "Unable to find $manifestFilePath"
}

#################################################################################################

Install-Module Pester -Force
Invoke-Pester

#################################################################################################

if (Test-ModuleManifest -Path "$manifestFilePath") {
    $moduleRootPath = Resolve-Path "$env:moduleRoot"
    Publish-Module -Path "$moduleRootPath" -NuGetApiKey "$env:galleryPublishingKey"
    Write-Output "Module published!"
}
