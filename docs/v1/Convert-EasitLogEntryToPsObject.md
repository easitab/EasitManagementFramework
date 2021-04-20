---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Convert-EasitLogEntryToPsObject.md
schema: 2.0.0
---

# Convert-EasitLogEntryToPsObject

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```
Convert-EasitLogEntryToPsObject [[-String] <String>] [[-Source] <String>] [<CommonParameters>]
```

## DESCRIPTION

Parses and log entries in "Easit logs" and converts them to PSObjects.

## EXAMPLES

### Example 1

```powershell
PS C:\> $logEvent | Convert-EasitLogEntryToPsObject -Source "$source"
```

In this example the string in $logEvent look like this: ``date time level - message [java class]``

## PARAMETERS

### -Source

Source of the log entry, the file that the log entry is from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -String

String to parse and convert.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Convert-EasitLogEntryToPsObject.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Convert-EasitLogEntryToPsObject.md)

