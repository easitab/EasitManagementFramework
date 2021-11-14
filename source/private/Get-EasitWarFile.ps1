function Get-EasitWarFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [Parameter(Mandatory)]
        [string]$Name
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!(Test-Path -Path $Path)) {
            throw "Unable to find $Path"
        }
        try {
            $folders = Get-ChildItem -Path $Path -Exclude 'files', 'solr*' -Directory
        } catch {
            throw $_
        }
        foreach ($folder in $folders) {
            try {
                Get-ChildItem -Path $folder -Include "$Name" -File -Recurse
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}