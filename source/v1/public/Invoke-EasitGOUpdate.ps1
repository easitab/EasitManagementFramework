function Invoke-EasitGOUpdate {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-EasitGOUpdate.md")]
    param (
        [Parameter()]
        [string] $EmfHome = "${env:ALLUSERSPROFILE}\EMF",
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter()]
        [string] $EmfConfigurationName = 'Dev',
        [Parameter()]
        [string] $UpdateResourceDirectory = $null,
        [Parameter(Mandatory)]
        [string] $UpdateFilename,
        [Parameter()]
        [switch] $RunningElevated,
        [Parameter()]
        [switch] $SkipDbBackup,
        [Parameter()]
        [switch] $StoredProcedureName
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        if (!($RunningElevated)) {
            throw "Session is not running with elevated priviliges that is need to perfom this action, ensure you are running an elevated session and specify -RunningElevated"
        }
        $emfConfig = Get-EMFConfig -EMFHome $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
    }

    process {
        if ([string]::IsNullOrWhiteSpace($UpdateResourceDirectory)) {
            if ([string]::IsNullOrWhiteSpace($emfConfig.UpdateResourceDirectory)) {
                throw "No path provided as UpdateResourceDirectory. Use -UpdateResourceDirectory or UpdateResourceDirectory in $EmfHome\$EmfConfigurationFileName"
            } else {
                $UpdateResourceDirectory = "$($emfConfig.UpdateResourceDirectory)"
            }
        }
        if (Test-Path -Path "$UpdateResourceDirectory") {
            Write-Verbose "Using $UpdateResourceDirectory as UpdateResourceDirectory"
        } else {
            throw "Unable to find $UpdateResourceDirectory"
        }

        if ([string]::IsNullOrWhiteSpace($emfConfig.SystemRoot)) {
            throw "No path provided as SystemRoot. Please update SystemRoot in $EmfHome\$EmfConfigurationFileName for GO"
        } else {
            if (!(Test-Path -Path "$($emfConfig.SystemRoot)")) {
                throw "Unable to find $($emfConfig.SystemRoot)"
            } else {
                $systemRoot = "$($emfConfig.SystemRoot)"
                Write-Verbose "Using systemRoot: $systemRoot"
            }
        }

        if ([string]::IsNullOrWhiteSpace($emfConfig.BackupRoot)) {
            throw "No path provided as BackupRoot. Please update BackupRoot in $EmfHome\$EmfConfigurationFileName for GO"
        } else {
            if (!(Test-Path -Path "$($emfConfig.BackupRoot)")) {
                try {
                    $backupRootName = Split-Path -Path "$($emfConfig.BackupRoot)" -Leaf
                    $backupRootParent = Split-Path -Path "$($emfConfig.BackupRoot)" -Parent
                    $backupRoot = New-Item -Path $backupRootParent -Name $backupRootName -ItemType Directory
                } catch {
                    throw $_
                }
                Write-Verbose "Created directory named $backupRootName in $backupRootParent"
            } else {
                $backupRoot = "$($emfConfig.BackupRoot)"
            }
        }
        Write-Verbose "Using backupRoot: $backupRoot"
        $foldersToFind = @('config','logs','webapps')
        foreach ($folderToFind in $foldersToFind) {
            $varName = "${folderToFind}Root"
            if (!(Get-Variable -Name "$varName" -ErrorAction SilentlyContinue)) {
                New-Variable -Name "$varName"
            }
            Set-Variable -Name "$varName" -Value (Get-ChildItem -Path "$systemRoot" -Include "$folderToFind" -Directory -Recurse).Fullname
            if (!(Get-Variable -Name "$varName" -ValueOnly)) {
                Set-Variable -Name "$varName" -Value (Get-ChildItem -Path "$systemRoot" -Include "$folderToFind" -Directory -Recurse).Fullname
                if (!(Get-Variable -Name "$varName" -ValueOnly)) {
                    throw "Unable to find ${varName}"
                }
            }
            $varValue = Get-Variable -Name "$varName" -ValueOnly
            Write-Verbose "Using ${varName}: $varValue"
        }
        
        try {
            $systemConfigFile = (Get-ChildItem -Path "$configRoot" -Include 'properties.xml' -File -Recurse).Fullname
        } catch {
            throw $_
        }
        if (!($systemConfigFile)) {
            throw "Unable to find configRoot: $configRoot"
        }
        Write-Verbose "Found systemConfigFile: $systemConfigFile"
        try {
            $systemProperties = Import-EMFXMLData -Path $systemConfigFile -ReturnAsPSObject
        } catch {
            throw $_
        }
        Write-Verbose "Got system properties"

        try {
            $warFile = (Get-EasitWarFile -Path "$systemRoot" -Name "$($emfConfig.WarName).war").Fullname
        } catch {
            throw $_
        }
        if (!($warFile)) {
            try {
                $warFile = (Get-EasitWarFile -Path "$($emfConfig.TomcatRoot)" -Name "$($emfConfig.WarName).war").Fullname
            } catch {
                throw $_
            }
            if (!($warFile)) {
                throw "Unable to find warFile: $warFile"
            }
        }
        Write-Verbose "Using warFile: $warFile"
        $UpdateFile = Join-Path -Path $UpdateResourceDirectory -ChildPath $UpdateFilename
        Write-Information "Trying to find update file" -InformationAction Continue
        if (Test-Path -Path $UpdateFile) {
            Write-Information "Using UpdateFile: $UpdateFile" -InformationAction Continue
        } else {
            throw "Unable to find $UpdateFile"
        }
        try {
            $service = Get-EasitService -ServiceName "$($emfConfig.ServiceName)"
            Write-Information "Found service $($service.Name)" -InformationAction Continue
        } catch {
            throw "Unable to find service for Easit GO"
        }

        if (!($SkipDbBackup)) {
            $rawDbUrl = "$($systemProperties.'dataSource.url')"
            try {
                $dbConnectionDetails = Get-DatabaseDetails -Uri $rawDbUrl
                Write-Verbose $dbConnectionDetails
            } catch {
                Write-Verbose $dbConnectionDetails
                throw "Unable to resolve database connection details"
            }
            if ($dbConnectionDetails.supportedProtocol) {
                Write-Warning "EasitManagementFramework only supports MSSQL at the moment. Perform manual backup of database and specify -SkipDbBackup"
                break
            } else {
                $useLocalCommand = $false
                if (Get-Command -Module 'SqlServer') {
                    Write-Verbose "Found module SqlServer"
                    $useLocalCommand = $true
                } else {
                    Write-Verbose "Module SqlServer is not installed on this computer, will attempt to connect to sql server $($dbConnectionDetails.dbServerName)"
                    if (!(Test-NetConnection -ComputerName "$($dbConnectionDetails.dbServerName)" -Port $dbConnectionDetails.dbServerPort)) {
                        throw "Unable to connect to sql server $($dbConnectionDetails.dbServerName) on port $($dbConnectionDetails.dbServerPort), check connection or perform manual backup of database and specify -SkipDbBackup"
                    }
                    Write-Verbose "Successfully connected to sql server $($dbConnectionDetails.dbServerName)"
                }
            }
        }
        Write-Information "Starting update process for Easit GO" -InformationAction Continue
        Write-Information "Stopping service" -InformationAction Continue
        try {
            $service = Stop-EasitGOApplication -EMFHome $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName -RunningElevated:$RunningElevated
        } catch {
            throw $_
        }
        Write-Information "Service stopped" -InformationAction Continue
        if ($SkipDbBackup) {
            Write-Warning "-SkipDbBackup is specified, assuming manual backup of database have been done"
        }
        if (!($SkipDbBackup)) {
            $LASTEXITCODE = 0
            $ErrorActionPreference = 'Stop'
            Write-Information "Attempting to execute stored procedure on database server" -InformationAction Continue
            if ($useLocalCommand) {
                if ($dbConnectionDetails.dbInstance) {
                    $serverInstance = "$($dbConnectionDetails.dbServerName)\$($dbConnectionDetails.dbInstance)"
                } else {
                    $serverInstance = "$($dbConnectionDetails.dbServerName)"
                }
                try {
                    Invoke-Sqlcmd -ServerInstance "$serverInstance" -Database "$($dbConnectionDetails.dbName)" -Query "EXEC $StoredProcedureName" -OutputSqlErrors $true
                } catch {
                    throw $_
                }
                if ($LASTEXITCODE -ne 0) {
                    throw "Invoke-Sqlcmd returned $LASTEXITCODE"
                }
            }
            if (!($useLocalCommand)) {
                try {
                    $dbSession = New-PSSession -ComputerName "$dbServer"
                    Enter-PSSession -Session $dbSession
                } catch {
                    throw $_
                }
                Invoke-Sqlcmd -Database "$dbName" -Query "EXEC $StoredProcedureName" -OutputSqlErrors $true -ErrorAction Continue
                Exit-PSSession
                Remove-PSSession -Session $dbSession
                if ($LASTEXITCODE -ne 0) {
                    throw "Invoke-Sqlcmd returned $LASTEXITCODE"
                }
            }
            $ErrorActionPreference = $null
            $LASTEXITCODE = 0
            Write-Information "Backup of database complete" -InformationAction Continue
        }
        Write-Information "Perfoming backup action on files and folders" -InformationAction Continue
        $foldersToBackup = @("$configRoot","$logsRoot","$warFile")
        foreach ($folder in $foldersToBackup) {
            try {
                Backup-EasitFolder -FolderToBackup "$folder" -DestinationFolder $backupRoot
            } catch {
                throw $_
            }
        }
        try {
            Write-Verbose "Removing $logsRoot"
            Remove-Item "$logsRoot" -Include '*.*' -Recurse -Force -Confirm:$false -InformationAction SilentlyContinue
            Write-Verbose "$logsRoot removed"
        } catch {
            Write-Warning "$($_.Exception)"
        }
        try {
            Write-Verbose "Removing $warFile"
            Remove-Item "$warFile" -Confirm:$false -InformationAction SilentlyContinue
            Write-Verbose "$warFile removed"
        } catch {
            Write-Warning "$($_.Exception)"
        }
        $expandedWarFolder = Join-Path -Path "$webappsRoot" -ChildPath "$($emfConfig.WarName)"
        try {
            Write-Verbose "Removing $expandedWarFolder"
            Remove-Item "$expandedWarFolder" -Recurse -Force -Confirm:$false -InformationAction SilentlyContinue
            Write-Verbose "$expandedWarFolder removed"
        } catch {
            Write-Warning "$($_.Exception)"
        }
        Write-Information "Backup of files and folders have been completed" -InformationAction Continue

        Write-Information "Updating war file" -InformationAction Continue
        $newWarToCopy = Join-Path -Path "$($emfConfig.UpdateResourceDirectory)" -ChildPath "$UpdateFilename"
        Write-Verbose "Looking for $UpdateFilename in $($emfConfig.UpdateResourceDirectory)"
        if (!(Test-Path -Path $newWarToCopy)) {
            throw "Unable to find $newWarToCopy. Update can be completed by copying new war ($UpdateFilename) file to $webappsRoot and running Start-EasitGOApplication"
        }
        try {
            Copy-Item -Path "$newWarToCopy" -Destination "$webappsRoot"
            Get-ChildItem -Path "$webappsRoot\${UpdateFilename}" | Rename-Item -NewName "$($emfConfig.WarName).war"
        } catch {
            throw $_
        }
        Write-Information "Starting service" -InformationAction Continue
        try {
            $service = Start-EasitGOApplication -EMFHome $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName -Verify -RunningElevated:$RunningElevated
        } catch {
            throw $_
        }
        Write-Information "Update of Easit GO have been completed" -InformationAction Continue
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}