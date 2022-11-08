function Invoke-Email2GOUpdate {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-Email2GOUpdate.md")]
    param (
        [Parameter()]
        [string] $EmfHome = "${env:ALLUSERSPROFILE}\EMF",
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter()]
        [string] $EmfConfigurationName = 'Email2GO',
        [Parameter()]
        [string] $UpdateResourceDirectory = $null,
        [Parameter(Mandatory)]
        [string] $UpdateFilename,
        [Parameter()]
        [switch] $RunningElevated,
        [Parameter()]
        [switch] $Cleanup
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
            throw "No path provided as SystemRoot. Please update SystemRoot in $EmfHome\$EmfConfigurationFileName for Email2GO"
        } else {
            if (!(Test-Path -Path "$($emfConfig.SystemRoot)")) {
                throw "Unable to find $($emfConfig.SystemRoot)"
            } else {
                $systemRoot = "$($emfConfig.SystemRoot)"
                Write-Verbose "Using systemRoot: $systemRoot"
            }
        }
        
        if ([string]::IsNullOrWhiteSpace($emfConfig.BackupRoot)) {
            throw "No path provided as BackupRoot. Please update BackupRoot in $EmfHome\$EmfConfigurationFileName for Email2GO"
        } else {
            if (!(Test-Path -Path "$($emfConfig.BackupRoot)")) {
                $backupRootName = Split-Path -Path "$($emfConfig.BackupRoot)" -Leaf
                $backupRootParent = Split-Path -Path "$($emfConfig.BackupRoot)" -Parent
                $backupRoot = New-Item -Path $backupRootParent -Name $backupRootName -ItemType Directory
                Write-Verbose "Created directory named $backupRootName in $backupRootParent"
            } else {
                $backupRoot = "$($emfConfig.BackupRoot)"
            }
        }
        Write-Verbose "Using backupRoot: $backupRoot"

        $configRoot = Join-Path -Path $systemRoot -ChildPath 'config'
        if (!(Test-Path $configRoot)) {
            throw "Unable to find configRoot: $configRoot"
        } else {
            Write-Verbose "Using configRoot: $configRoot"
        }

        $UpdateFile = Join-Path -Path $UpdateResourceDirectory -ChildPath $UpdateFilename
        $todayMinute = Get-Date -Format "yyyyMMdd_HHmm"
        Write-Information "Trying to find update file" -InformationAction Continue
        if (Test-Path -Path $UpdateFile) {
            if ($UpdateFile -match '\.zip$') {
                $expandedArchiveFolder = Join-Path -Path $UpdateResourceDirectory -ChildPath "$todayMinute"
                if (!(Test-Path -Path $expandedArchiveFolder)) {
                    try {
                        Write-Verbose "Creating $expandedArchiveFolder"
                        $expandedArchiveFolder = New-Item -Path $UpdateResourceDirectory -Name $todayMinute -ItemType Directory
                    } catch {
                        throw $_
                    }
                } else {
                    try {
                        Write-Verbose "$expandedArchiveFolder already exist, removing files in folder"
                        Get-ChildItem $expandedArchiveFolder | Remove-Item
                        Write-Verbose "Files removed"
                    } catch {
                        throw $_
                    }
                }
                try {
                    Expand-Archive -Path $UpdateFile -DestinationPath $expandedArchiveFolder -InformationAction SilentlyContinue
                    $UpdateFile = (Get-ChildItem -Path $expandedArchiveFolder | Where-Object -Property Name -Like '*.msp').Fullname
                } catch {
                    throw $_
                }
            }
            Write-Information "Using UpdateFile: $UpdateFile" -InformationAction Continue
        } else {
            throw "Unable to find $UpdateFile"
        }
        try {
            $service = Get-EasitService -ServiceName '%mail2go%'
            Write-Information "Found service $($service.Name)" -InformationAction Continue
        } catch {
            throw "Unable to find service for Email2GO"
        }
        Write-Information "Starting update process for Email2GO" -InformationAction Continue
        Write-Information "Stopping service" -InformationAction Continue
        try {
            $service = Set-EasitService -Service $service -Action 'StopService'
        } catch {
            throw $_
        }
        Write-Information "Service stopped" -InformationAction Continue
        $logs = Join-Path -Path $systemRoot -ChildPath 'logs'
        $email2GOFoldersToBackup = @("$configRoot","$logs")
        foreach ($folder in $email2GOFoldersToBackup) {
            try {
                Backup-EasitFolder -FolderToBackup "$folder" -DestinationFolder $backupRoot -Cleanup $Cleanup
            } catch {
                throw $_
            }
        }
        try {
            $updateProcess = Start-Process -FilePath $UpdateFile -Wait -PassThru
        } catch {
            throw $_
        }
        if ($updateProcess.ExitCode -ne '0') {
            if ($updateProcess.ExitCode -eq '1602') {
                Write-Information "Update process terminated" -InformationAction Continue
            } else {
                Write-Warning "The update process did not exit (ExitCode: $($updateProcess.ExitCode)) successfully, therefor $($MyInvocation.MyCommand) have been terminated and manual update of Email2GO is needed"
            }
            return
        }
        try {
            Get-ChildItem -Path $expandedArchiveFolder | Remove-Item
            Remove-Item -Path $expandedArchiveFolder
            Write-Verbose "Removed $expandedArchiveFolder and its contents"
        } catch {
            throw $_
        }
        try {
            $service = Get-EasitService -ServiceName "$($service.Name)"
            Write-Verbose "Found service $($service.Name)"
            if ("$($service.State)" -ne 'Running') {
                Write-Information "Trying to start service $($service.Name)" -InformationAction Continue
                $service = Set-EasitService -Service $service -Action 'StartService'
            } else {
                Write-Verbose "Service $($service.Name) is running"
            }
        } catch {
            throw $_
        }        
        Write-Information "Email2GO successfully updated" -InformationAction Continue
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}