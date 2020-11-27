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
    }
    
    process {
        if (!(Test-Path -Path $EMFHome)) {
            try {
                $null = New-Item -Path "$Home" -Name 'EMF' -ItemType Directory
                Write-Verbose -Message "Created directory EMF in $Home"
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
        Write-Output "Downloading assets..."
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
        Write-Output "Download of assets complete"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}