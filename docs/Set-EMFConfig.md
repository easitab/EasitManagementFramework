---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version:
schema: 2.0.0
---

# Set-EMFConfig

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Manual
```
Set-EMFConfig [-EMFHome <String>] [-ConfigurationFileName <String>] [-ConfigurationName] <String>
 -EasitRoot <String> [-SystemRoot <String>] [-ServiceName <String>] [-TomcatRoot <String>]
 [-BackupRoot <String>] [-EmailRequestRoot <String>] [-ImportClientRoot <String>] [<CommonParameters>]
```

### Array
```
Set-EMFConfig [-EMFHome <String>] [-ConfigurationFileName <String>] [-ConfigurationName] <String>
 -PropertySetting <String[]> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -BackupRoot
{{ Fill BackupRoot Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationFileName
{{ Fill ConfigurationFileName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: file, filename

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationName
{{ Fill ConfigurationName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: ConfigName

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EasitRoot
{{ Fill EasitRoot Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailRequestRoot
{{ Fill EmailRequestRoot Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases: ER, EmailRequest, erRoot

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EMFHome
{{ Fill EMFHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: Home

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportClientRoot
{{ Fill ImportClientRoot Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases: IC, ImportClient, icRoot

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertySetting
{{ Fill PropertySetting Description }}

```yaml
Type: String[]
Parameter Sets: Array
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceName
{{ Fill ServiceName Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemRoot
{{ Fill SystemRoot Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TomcatRoot
{{ Fill TomcatRoot Description }}

```yaml
Type: String
Parameter Sets: Manual
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
