function Test-ForFileLock {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Test-ForFileLock.md")]
    param (
        [Parameter(Mandatory)]
        [string]$FilePath
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        Write-Verbose "Checking if $FilePath is locked"
        $fileInfo = New-Object System.IO.FileInfo $FilePath
        try {
            $fileStream = $fileInfo.Open( [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
            Write-Verbose "$FilePath is not locked"
            $returnValue = $false
        } catch {
            Write-Verbose "$FilePath is locked"
            $returnValue = $true
        }
        $fileStream.Close()
        $fileStream.Dispose()
        return $returnValue
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}