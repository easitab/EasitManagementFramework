function Get-EasitJavaKeyTool {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $javaPath = Join-Path -Path $Path -ChildPath 'Java'
        if (Test-Path $javaPath) {
            try {
                Get-ChildItem "$javaPath\*" -Include 'keytool.exe' -Recurse | Sort-Object {[version]$_.VersionInfo.FileVersion} | Select-Object -Last 1
            } catch {
                throw $_
            }
        } else {
            throw "$javaPath is not a valid path"
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}