function Backup-EasitFolder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $FolderToBackup,
        [Parameter(Mandatory)]
        [string] $DestinationFolder,
        [Parameter()]
        [string] $ArchiveName,
        [Parameter()]
        [boolean] $Cleanup
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $today = Get-Date -Format "yyyyMMdd"
        $now = Get-Date -Format "yyyyMMdd_HHmmss"
        $todayDestinationFolder = Join-Path -Path "$DestinationFolder" -ChildPath "$today"
        if ([string]::IsNullOrWhiteSpace($ArchiveName)) {
            $leaf = Split-Path $FolderToBackup -Leaf
            $ArchiveName = "${leaf}_${now}"
        }
        Write-Verbose "Using $ArchiveName as ArchiveName"
        if (!(Test-Path -Path $todayDestinationFolder)) {
            try {
                $todayDestinationFolder = (New-Item -Path $DestinationFolder -Name "$today" -ItemType Directory).FullName
                Write-Verbose "Created $todayDestinationFolder"
            } catch {
                throw $_
            }
        }
        Write-Verbose "Using $todayDestinationFolder as todayDestinationFolder"
        $zipFile = Join-Path -Path $todayDestinationFolder -ChildPath "$ArchiveName.zip"
        try {
            $compress = @{
                Path = "$FolderToBackup"
                CompressionLevel = "Optimal"
                DestinationPath = "$zipFile"
            }
            Compress-Archive @compress -InformationAction SilentlyContinue
            Write-Verbose "Created zip archive for $FolderToBackup"
        } catch {
            throw $_
        }
        if ($Cleanup) {
            try {
                Remove-Item $FolderToBackup -Recurse -Force -InformationAction SilentlyContinue
                Write-Verbose "Removed $FolderToBackup"
            } catch {
                throw $_
            }
        } else {
            Write-Verbose "Cleanup has not been specified, leaving $FolderToBackup as is"
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}