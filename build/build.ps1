New-Module -Name "$env:moduleName" -ScriptBlock {
    $modulePath = "$env:sourceRoot\$env:moduleName.psm1"
    $privScripts = Get-ChildItem -Path "$env:sourceRoot\private" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$env:sourceRoot\public" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        $newModuleFile = New-Item -Path "$env:sourceRoot" -Name "$env:moduleName.psm1" -ItemType "file"
        Write-Host "Created $newModuleFile"
    }
    foreach ($privateScript in $privScripts) {
        $scriptContent = Get-Content -Path "$($privateScript.FullName)" -Raw
        if (Test-Path -Path $modulePath) {
            Add-Content -Path $modulePath -Value $scriptContent
        } else {
            Write-Host "Unable to find modulePath at $modulePath" -ForegroundColor Red
        }
    }
    foreach ($publicScript in $pubScripts) {
        $exportFunction = "Export-ModuleMember -Function $($publicScript.BaseName)"
        $scriptName = "$($publicScript.Name)"
        "$($publicScript.FullName)"
        $scriptContent = Get-Content -Path "$($publicScript.FullName)" -Raw
        if (Test-Path -Path $modulePath) {            
            Add-Content -Path $modulePath -Value $exportFunction
        } else {
            Write-Host "Unable to find modulePath at $modulePath" -ForegroundColor Red
        }
    }
}

$manifest = @{
    Path              = "$env:sourceRoot\$env:moduleName.psd1" 
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