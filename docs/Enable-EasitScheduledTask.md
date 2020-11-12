---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/Enable-EasitScheduledTask.md
schema: 2.0.0
---

# Enable-EasitScheduledTask

## SYNOPSIS
Enable scheduled "Easit task" in Windows Task Scheduler

## SYNTAX

### InputObject
```
Enable-EasitScheduledTask [-InputObject <CimInstance>] [-AsJob] [<CommonParameters>]
```

### TaskName
```
Enable-EasitScheduledTask [-TaskName <String>] [-AsJob] [<CommonParameters>]
```

## DESCRIPTION
The *Enable-EasitScheduledTask* cmdlet enables one or more scheduled "Easit tasks" in Windows Task Scheduler.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-EasitScheduledTask | Enable-EasitScheduledTask
```

In this example all Easit tasks will be enabled.

### Example 2
```powershell
PS C:\> $taskObj = Get-EasitScheduledTask
PS C:\> $taskObj | Enable-EasitScheduledTask
```

In this example all Easit tasks will be enabled.

### Example 3
```powershell
PS C:\> $taskObj = Get-EasitScheduledTask
PS C:\> Enable-EasitScheduledTask -InputObject $taskObj
```

In this example all Easit tasks will be enabled.

### Example 4
```powershell
PS C:\> Enable-EasitScheduledTask -TaskName 'Easit EmailRequest'
```

In this example an Easit tasks with the exact name 'Easit EmailRequest' will be enabled. The parameter TaskName do not support wilcards.

### Example 5
```powershell
PS C:\> $taskObj = Get-EasitScheduledTask -EmailRequest
PS C:\> Enable-EasitScheduledTask -TaskName "$($taskObj.TaskName)"
```

In this example an Easit tasks called 'Easit EmailRequest' will be enabled.

## PARAMETERS

### -AsJob
Runs the cmdlet as a background job. Use this parameter to run commands that take a long time to complete.

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

### -InputObject
Specifies the input object that is used in a pipeline command.

```yaml
Type: CimInstance
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TaskName
Specifies the name of a scheduled task.

```yaml
Type: String
Parameter Sets: TaskName
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

### Microsoft.Management.Infrastructure.CimInstance

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
