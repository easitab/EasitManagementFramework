---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EasitScheduledTask.md
schema: 2.0.0
---

# Get-EasitScheduledTask

## SYNOPSIS

Get scheduled Easit tasks.

## SYNTAX

```
Get-EasitScheduledTask [-EmailRequest] [-ImportClient] [<CommonParameters>]
```

## DESCRIPTION

The *Get-EasitScheduledTask* cmdlet gets scheduled tasks from Windows Task Scheduler. You can get all Easit tasks or use the *EmailRequest* or *ImportClient* parameter to specify the task.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-EasitScheduledTask
```

This example gets all scheduled tasks with the string *easit* in its name.

### Example 2

```powershell
PS C:\> Get-EasitScheduledTask -EmailRequest
```

This example gets all scheduled tasks with the string *easit* and *mail* in its name.

### Example 3

```powershell
PS C:\> Get-EasitScheduledTask -EmailRequest -ImportClient
```

This example gets all scheduled tasks with the string *easit*, *mail* and *import* in its name.
This example with provide the same result as running the cmdlet twice, once for each parameter.

## PARAMETERS

### -EmailRequest

Switch to specify if only to get tasks containing *mail* in its name.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportClient

Switch to specify if only to get tasks containing *import* in its name.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
