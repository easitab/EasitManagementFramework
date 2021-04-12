function Initialize-EasitManagementFramework {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Home')]
        [string] $EMFHome = "$Home\EMF",
        [Parameter()]
        [string] $ConfigURL = 'https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/configurations/emfConfig.xml',
        [Parameter()]
        [string] $SchemaURL = 'https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/schemas/emfConfig.xsd',
        [Parameter()]
        [string] $ConfigName = 'emfConfig.xml',
        [Parameter()]
        [string] $SchemaName = 'emfConfig.xsd'
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized!"
        $ProgressPreference = 'SilentlyContinue'
    }
    
    process {
        if (!(Test-Path -Path $EMFHome)) {
            try {
                $null = New-Item -Path "$Home" -Name 'EMF' -ItemType Directory
                Write-Information "Created directory EMF in $Home" -InformationAction Continue
            } catch {
                throw $_
            }
        } else {
            Write-Verbose "Found $EMFHome"
        }
        try {
            $wc = New-Object System.Net.WebClient
            Write-Verbose "Created WebClient"
        } catch {
            throw $_
        }
        Write-Information "Downloading assets..." -InformationAction Continue
        try {
            $output1 = Join-Path -Path "$EMFHome" -ChildPath "$ConfigName"
            $wc.DownloadFile($ConfigURL, $output1)
            Write-Verbose "Download of $ConfigName complete"
        } catch {
            throw $_
        }
        try {
            $output2 = Join-Path -Path "$EMFHome" -ChildPath "$SchemaName"
            $wc.DownloadFile($SchemaURL, $output2)
            Write-Verbose "Download of $SchemaName complete"
        } catch {
            throw $_
        }
        Write-Information "Download of assets complete" -InformationAction Continue
    }
    
    end {
        $ProgressPreference = 'Continue'
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}