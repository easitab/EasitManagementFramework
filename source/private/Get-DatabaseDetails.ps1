function Get-DatabaseDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Uri
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $returnObject = New-Object PSObject
        $multiConnDets = $false
        if ($Uri -match 'sqlserver') {
            Write-Verbose "ConnString is for MSSQL"
            $supportedProtocol = $true
            $dbConnectionDetails = $Uri -split ';'
            if ($dbConnectionDetails.Count -ne '1') {
                $multiConnDets = $true
            }
        }
        if ($Uri -match 'mysql') {
            Write-Verbose "ConnString is for MySQL"
            $supportedProtocol = $false
            $cleanDbUrl = $Uri -replace '.+\:.+\:\/\/',''
            Write-Verbose "cleanDbUrl = $cleanDbUrl"
            $dbName = Split-Path $cleanDbUrl -Leaf
            $dbServerUrl = Split-Path $cleanDbUrl -Parent
            $dbServerUrlDetails = $dbServerUrl -split ':'
            $dbServerName = $dbServerUrlDetails[0]
            if ($dbServerUrlDetails[1]) {
                $dbServerPort = $dbServerUrlDetails[1]
            } else {
                $dbServerPort = 3306
            }
        }
        
        if ($multiConnDets) {
            Write-Verbose "Multiple connections details"
            foreach ($dbConnectionDetail in $dbConnectionDetails) {
                Write-Verbose $dbConnectionDetail
                if ($dbConnectionDetail -match '.+\:.+\:\/\/.*') {
                    $dbServerDetails = $dbConnectionDetail -replace '.+\:.+\:\/\/',''
                    if ($dbServerDetails -match '\\\\') {
                        Write-Verbose "$dbServerDetails contains \\"
                        $dbInstanceDetails = $dbServerDetails -split '\\\\'
                        Write-Verbose "dbInstanceDetails = $dbInstanceDetails"
                        $dbInstance = $dbInstanceDetails[1]
                        $dbServerDetails = $dbInstanceDetails[0]
                    }
                    if ($dbServerDetails -match ':') {
                        Write-Verbose "$dbServerDetails contains :"
                        $dbServerUrlDetails = $dbServerDetails -split ':'
                        Write-Verbose "dbServerUrlDetails = $dbServerUrlDetails"
                        $dbServerName = $dbServerUrlDetails[0]
                        $dbServerPort = $dbServerUrlDetails[1]
                    } 
                    if (!($dbServerName)) {
                        $dbServerName = $dbServerDetails
                    }
                    if (!($dbServerPort)) {
                        $dbServerPort = 1433
                    }
                    if (!($dbInstance)) {
                        $dbInstance = $null
                    }
                }
                if ($dbConnectionDetail -match 'databaseName.*') {
                    $dbName = $dbConnectionDetail -replace 'databaseName=',''
                }
            }
        }
        try {
            Write-Verbose "dbServerName = $dbServerName"
            $returnObject | Add-Member -MemberType NoteProperty -Name 'dbServerName' -Value "$dbServerName"
            Write-Verbose "dbServerPort = $dbServerPort"
            $returnObject | Add-Member -MemberType NoteProperty -Name 'dbServerPort' -Value "$dbServerPort"
            Write-Verbose "dbName = $dbName"
            $returnObject | Add-Member -MemberType NoteProperty -Name 'dbName' -Value "$dbName"
            Write-Verbose "dbInstance = $dbInstance"
            $returnObject | Add-Member -MemberType NoteProperty -Name 'dbInstance' -Value "$dbInstance"
            Write-Verbose "supportedProtocol = $supportedProtocol"
            $returnObject | Add-Member -MemberType NoteProperty -Name 'supportedProtocol' -Value "$supportedProtocol"
            return $returnObject
        } catch {
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}