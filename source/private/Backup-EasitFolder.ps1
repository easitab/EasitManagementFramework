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
            Add-Type -Assembly System.IO.Compression.FileSystem
            $compressionLevel = [IO.Compression.CompressionLevel]::Optimal
            if (Test-Path -Path $FolderToBackup -PathType Leaf) {
                try {
                    $zip = [System.IO.Compression.ZipFile]::Open($zipFile, 'create')
                    $zip.Dispose()
                    $zip = [System.IO.Compression.ZipFile]::Open($zipFile, 'update')
                    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $FolderToBackup, $leaf, $compressionLevel) | Out-Null
                    $zip.Dispose()
                } catch {
                    $zip.Dispose()
                    Remove-Item $zipFile -Recurse -Force -Confirm:$false -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
                    Remove-Item $zip -Recurse -Force -Confirm:$false -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
                    $trySlowWay = $true
                }
            }
            if (Test-Path -Path $FolderToBackup -PathType Container) {
                try {
                    [IO.Compression.ZipFile]::CreateFromDirectory($FolderToBackup, $zipFile, $compressionLevel, $false)
                } catch {
                    Remove-Item $zipFile -Recurse -Force -Confirm:$false -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
                    $trySlowWay = $true
                }
            }
            if ($trySlowWay -or !(Test-Path -Path $zipFile)) {
                Compress-Archive @compress -InformationAction SilentlyContinue
            }
            Write-Verbose "Created zip archive for $FolderToBackup"
        } catch {
            throw $_
        }
        if ($Cleanup) {
            try {
                Remove-Item $FolderToBackup -Recurse -Force -Confirm:$false -InformationAction SilentlyContinue
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