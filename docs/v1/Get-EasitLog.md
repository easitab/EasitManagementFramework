---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Get-EasitLog.md
schema: 2.0.0
---

# Get-EasitLog

## SYNOPSIS

Get log entries from Easit GO.

## SYNTAX

### Configuration (Default)

The parameters in this set all have default values so unless you need to override these you can omit the parameters.

```powershell
Get-EasitLog [-EmfHome <String>] [-EmfConfigurationFileName <String>] [-EmfConfigurationName <String>]
 [<CommonParameters>]
```

### LiteralPath

Used if you only what to get entries from one specific log file.

```powershell
Get-EasitLog [-LiteralPath <String>] [<CommonParameters>]
```

### Path

Used if you want to get all or some log files in a specific directory.

```powershell
Get-EasitLog [-Path <String>] [-LogFilename <String>] [<CommonParameters>]
```

## DESCRIPTION

The *Get-EasitLog* cmdlet allows you to parse one or more "Easit logs" and get it contents as objects. The cmdlet gets all content from one or more "Easit logs" and considers each line starting with a date (2022-01-01) as an "entry" and each entry is returned as an object.

## EXAMPLES

### Example 1: Get all log entries from Easit*.log

This will return all entries in log files from production.

```powershell
PS C:\> Get-EasitLog
```

In this example we take advantage of the EMF-configuration file located in '$Home/EMF'. Since we omitted the parameter *EmfConfigurationName* we will use its default value.

### Example 2: Get log entries from Easit*.log - Test

This will return all entries in log files from test.

```powershell
PS C:\> Get-EasitLog -EmfConfigurationName 'Test'
```

In this example we take advantage of the EMF-configuration file located in '$Home/EMF', and the configuration named Test in it. This will return all entries in log files from test.

### Example 3: Get log entries - Specific log file

This will return all entries from one specific log file.

```powershell
PS C:\> Get-EasitLog -LiteralPath 'D:\Logs\easitGO.log'
```

In this example we specify what log file we would like to get entries from.

### Example 4: Get log entries - Specific path

This will return all entries from all log files named something like *easit*.

```powershell
PS C:\> Get-EasitLog -Path 'D:\Logs\'
```

In this example we specify what path we should look for log files in. All files named something like *easit* will be parsed and each entry in these logs will be returned.

### Example 5: Get log entries - Specific path, custom logname

This will return all entries from all log files named something like *easit*2021-01*.

```powershell
PS C:\> Get-EasitLog -Path 'D:\Logs\' -LogFilename '*easit*2021-01*'
```

In this example we specify what path we should look for log files in. All files named something like *easit*2021-01* will be parsed and each entry in these logs will be returned.

### Example 5: Get log entries - Custom EMF-Home folder

Custome root folder for EMF configuration and the configuration named *Dev*.

```powershell
PS C:\> Get-EasitLog -EmfHome 'D:\Easit\EMF' -EmfConfigurationName 'Dev'
```

In this example we will look for a file named *emfConfig.xml*. In the configuration named Dev we will use the value from *SystemRoot* to find a logs folder and from that folder return all entries from log files named something *easit*.

## PARAMETERS

### -EmfConfigurationFileName

Name of the configuration file to use.

```yaml
Type: String
Parameter Sets: Configuration
Aliases:

Required: False
Position: Named
Default value: emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationName

Name of configuration to use in the configuration file.

```yaml
Type: String
Parameter Sets: Configuration
Aliases:

Required: False
Position: Named
Default value: Prod
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfHome

Path to root directory for EasitManagementFramework.

```yaml
Type: String
Parameter Sets: Configuration
Aliases:

Required: False
Position: Named
Default value: $Home\EMF
Accept pipeline input: False
Accept wildcard characters: False
```

### -LiteralPath

Specifies a path to one log file. The value of LiteralPath is used exactly as it's typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell PowerShell to not interpret any characters as escape sequences.

```yaml
Type: String
Parameter Sets: LiteralPath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFilename

Name of log file to parse for entries. Wildcards *** can be used. A best effort will be performed to find log files matching the name.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Path to directory / folder to look for log files in.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Get-EasitLog.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Get-EasitLog.md)

