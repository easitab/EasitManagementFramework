function Get-EasitLog {
    [CmdletBinding(DefaultParameterSetName='Configuration',HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Get-EasitLog.md")]
    param (
        [Parameter(ParameterSetName='LiteralPath')]
        [string]$LiteralPath,
        [Parameter(ParameterSetName='Path')]
        [string]$Path,
        [Parameter(Mandatory,ParameterSetName='Path')]
        [string]$LogFilename,
        [Parameter(ParameterSetName = 'Configuration')]
        [string] $EmfHome = "${env:ALLUSERSPROFILE}\EMF",
        [Parameter(ParameterSetName = 'Configuration')]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter(Mandatory,Position=0,ParameterSetName = 'Configuration')]
        [Alias('system')]
        [string] $EmfConfigurationName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!($LiteralPath) -and !($Path)) {
            Write-Verbose "LiteralPath and Path are not provided.."
            try {
                Write-Verbose "Looking for EMF-Config"
                $emfConfig = Get-EMFConfig -Home $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
            } catch {
                throw $_
            }
            try {
                Write-Verbose "Joining path $($emfConfig.SystemRoot) and 'logs'"
                $Path = Join-Path "$($emfConfig.SystemRoot)" -ChildPath 'logs' -ErrorAction Stop
            } catch {
                throw $_
            }
            if (Test-Path -Path $Path) {
                Write-Verbose "Path = $Path"
            } else {
                Write-Verbose "Path = $Path"
                throw "Unable to find $Path. A valid path to logfiles need to be provided. This can be done with the following parameters 'LiteralPath' or 'Path'. If you would like to use your EMF-configurationfile place it in ${env:ALLUSERSPROFILE}\EMF and specify a value for SystemRoot (ex. D:\Easit\Systems\Prod) or use 'EmfHome', 'EmfConfigurationFileName' and 'EmfConfigurationName' parameters to take advantage from it."
            }
            
        } elseif ($Path) {
            if (Test-Path -Path $Path) {
                Write-Verbose "Path = $Path"
            } else {
                throw "Unable to find $Path"
            }
        } elseif ($LiteralPath) {
            if (Test-Path -Path $LiteralPath) {
                $Path = $LiteralPath
            } else {
                throw "Unable to find $LiteralPath"
            }
        } else {
            throw "Unable to figure out what to do. Either provide a 'LiteralPath', 'Path' and 'LogFilename' or a valid EMF-configurationfile"
        }
        if (!($LiteralPath)) {
            # If-block need to be performed for Get-ChildItem to work.
            if (Test-Path $Path -PathType Container) {
                if (!($Path -match '\\$')) {
                    $Path = "${Path}\"
                }
            }
            if ($LogFilename) {
                $gciParams = @{
                    Include = "*${LogFilename}*.log"
                    Exclude = $null
                }
            } else {
                $LogFilename = 'easit'
                $gciParams = @{
                    Include = '*easit*.log'
                    Exclude = '*stderr*', '*stdout*'
                }
            }
            try {
                $files = Get-ChildItem "${Path}*" @gciParams -ErrorAction Stop
                Write-Verbose "Collected all files matching *${LogFilename}*.log in $Path"
            } catch {
                throw $_
            }
        }
        if ($LiteralPath) {
            try {
                $files = Get-ChildItem "$Path" -ErrorAction Stop
                Write-Verbose "Collected $Path"
            } catch {
                throw $_
            }
        }
        
        foreach ($file in $files) {
            $logData += "`n1##$($file.Fullname)##`n"
            Write-Verbose "Getting content of $file"
            try {
                $encoding = [System.Text.Encoding]::UTF8
                $fileStream = [System.IO.FileStream]::new($file, 'Open', 'Read', 'ReadWrite')
                $textReader = [System.IO.StreamReader]::new($fileStream,$encoding)
                $collectedData = $textReader.ReadToEnd()
                if ([string]::IsNullOrWhiteSpace($collectedData)) {
                    Write-Verbose "$file did not contain any entries, skipping"
                    continue
                }
                if (!([string]::IsNullOrWhiteSpace($collectedData))) {
                    $collectedDataContainsData = $true
                }
                $logData += $collectedData
                Write-Verbose "Content collected"
            } catch [System.IO.IOException] {
                Write-Warning "$file locked by other process, skipping"
                continue
            } catch {
                Write-Warning "$($_.Exception), skipping"
                continue
            }
        }
        $returnObject = @()
        if ($collectedDataContainsData) {
            Write-Verbose "Splitting entries in logfile"
            $logEvents = $logData -split "(?=[\r|\n]+\d)"
            Write-Verbose "Converting entries to objects"
            foreach ($logEvent in $logEvents) {
                $logEvent = $logEvent.TrimEnd()
                $logEvent = $logEvent.TrimStart()
                if (Select-String -InputObject $logEvent -Pattern '##.+##' -Quiet) {
                    $source = Select-String -InputObject $logEvent -Pattern '##.+##'
                    $source = "$($source.Matches.Value)"
                    $source = $source.TrimStart('##')
                    $source = $source.TrimEnd('##')
                    Write-Verbose "source = $source"
                } else {
                    if ($logEvent.length -gt 0) {
                        try {
                            $returnObject += $logEvent | Convert-EasitLogEntryToPsObject -Source "$source"
                        } catch {
                            throw $_
                        }
                    }
                }
            }
            Write-Verbose "Returning converted entries as objects"
            return $returnObject
        } else {
            Write-Verbose "Log collection did not produce any entries"
            return
        }
    }

    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
