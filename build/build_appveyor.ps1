param (
    [string]$SourceRoot,
    [string]$ModuleName,
    [string]$CompanyName,
    [string]$ModuleAuthor,
    [string]$Version,
    [string]$HelpInfoUri,
    [string]$LicenseUri
)
$moduleArgs = "$SourceRoot", "$ModuleName"
New-Module -Name "$ModuleName" -ScriptBlock {
    param([string[]]$moduleParams)
    Write-Output "$moduleParams"
    $moduleSourceRoot = $moduleParams[0]
    Write-Output "$moduleSourceRoot"
    $moduleModuleName = $moduleParams[1]
    Write-Output "$moduleModuleName"
    $modulePath = "$moduleSourceRoot\$moduleModuleName.psm1"
    $privScripts = Get-ChildItem -Path "$moduleSourceRoot\private" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$moduleSourceRoot\public" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        New-Item -Path "$moduleSourceRoot" -Name "$moduleModuleName.psm1" -ItemType "file"
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
} -ArgumentList $moduleArgs
Get-ChildItem -Path "$SourceRoot"
$manifest = @{
    Path              = "$SourceRoot\$ModuleName.psd1" 
    RootModule        = "$ModuleName.psm1" 
    CompanyName       = "$CompanyName"
    Author            = "$ModuleAuthor"
    ModuleVersion     = "$Version"
    HelpInfoUri       = "$HelpInfoUri"
    LicenseUri        = "$LicenseUri"
    ProjectUri        = "$ProjectUri"
    Description       = 'Management Framework for Easit BPS and Easit GO'
    PowerShellVersion = '5.1'
    Copyright         = "(c) 2020 $CompanyName. All rights reserved."
}
New-ModuleManifest @manifest