param (
    $SourceRoot,
    $ModuleName,
    $CompanyName,
    $ModuleAuthor,
    $Version,
    $HelpInfoUri,
    $LicenseUri
)
New-Module -Name "$ModuleName" -ScriptBlock {
    $modulePath = "$SourceRoot\$ModuleName.psm1"
    $privScripts = Get-ChildItem -Path "$SourceRoot\private" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$SourceRoot\public" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        New-Item -Path "$SourceRoot" -Name "$ModuleName.psm1" -ItemType "file"
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