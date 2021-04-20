---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Convert-KeytoolResult.md
schema: 2.0.0
---

# Convert-KeytoolResult

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```
Convert-KeytoolResult [[-InputString] <String[]>] [[-ListCerts] <String>] [<CommonParameters>]
```

## DESCRIPTION

Converts output from keytool.exe to PSObject.

## EXAMPLES

### Example 1

```powershell
PS C:\> Convert-KeytoolResult -InputString $outputFromKeytool
```

## PARAMETERS

### -InputString

String with output from keytool to convert.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListCerts

Tells the cmdlet what formatting to expect.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
