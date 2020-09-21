New-Module -Name "$env:moduleName" -ScriptBlock {
    $modulePath = "$env:resourceRoot\$env:moduleName\$env:moduleName.psm1"
    $privScripts = Get-ChildItem -Path "$env:resourceRoot\src\priv" -Filter "*.ps1" -Recurse
    $pubScripts = Get-ChildItem -Path "$env:resourceRoot\src\pub" -Filter "*.ps1" -Recurse
    if (!(Test-Path -Path $modulePath)) {
        if (!(Test-Path -Path "$env:resourceRoot\$env:moduleName")) {
            New-Item -Path "$env:resourceRoot" -Name "$env:moduleName" -ItemType "directory" | Out-Null
            Write-Host "Created $env:resourceRoot\$env:moduleName"
        }
        $newModuleFile = New-Item -Path "$env:resourceRoot\$env:moduleName" -Name "$env:moduleName.psm1" -ItemType "file"
        Write-Host "Created $newModuleFile"
    }
    foreach ($privateScript in $privScripts) {
        $scriptName = "$($privateScript.Name)"
        $scriptContent = Get-Content -Path "$env:resourceRoot\$scriptName" -Raw
        if (Test-Path -Path $modulePath) {
            Add-Content -Path $modulePath -Value $scriptContent
        }
    }
    foreach ($publicScript in $pubScripts) {
        $exportFunction = "Export-ModuleMember -Function $($publicScript.BaseName)"
        $scriptName = "$($publicScript.Name)"
        $scriptContent = Get-Content -Path "$env:resourceRoot\$scriptName" -Raw
        if (Test-Path -Path $modulePath) {            
            Add-Content -Path $modulePath -Value $exportFunction
        }
    }
}

$manifest = @{
    Path              = "$env:resourceRoot\$env:moduleName\$env:moduleName.psd1" 
    RootModule        = "$env:moduleName.psm1" 
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