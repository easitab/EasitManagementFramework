---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/New-EMFConfig.md
schema: 2.0.0
---

# New-EMFConfig

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-EMFConfig [[-EMFHome] <String>] [[-ConfigurationFileName] <String>] [-ConfigurationName] <String>
 [-ConfigurationSettings] <Hashtable> [-Validate] [[-SchemaFile] <String>] [<CommonParameters>]
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

### -ConfigurationFileName
{{ Fill ConfigurationFileName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: file, filename

Required: False
Position: 1
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
Accepted values: Prod, Test, Dev, IntegrationProd, IntegrationTest, IntegrationDev

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationSettings
{{ Fill ConfigurationSettings Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: ConfigSettings

Required: True
Position: 3
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
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaFile
{{ Fill SchemaFile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Validate
{{ Fill Validate Description }}

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
