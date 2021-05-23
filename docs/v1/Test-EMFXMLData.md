---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Test-EMFXMLData.md
schema: 2.0.0
---

# Test-EMFXMLData

## SYNOPSIS

Validate configuration file against schema.

## SYNTAX

```
Test-EMFXMLData [[-EMFHome] <String>] [[-Path] <String>] [[-SchemaFile] <String>] [-ValidateSettings]
 [<CommonParameters>]
```

## DESCRIPTION

The *Test-EMFXMLData* cmdlet lets to test or verify that a configuration file is valid.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-EMFXMLData
```

By just running *Test-EMFXMLData* a validation of *$EMFHome\emfConfig.xml* will be done with the schema provided in *$EMFHome\emfConfig.xsd*.

### Example 2

```powershell
PS C:\> Test-EMFXMLData -EMFHome 'D:\EMF'
```

If your EMFHome location is another than $Home\EMF you can use this example instead of example 1.

### Example 3

```powershell
PS C:\> Test-EMFXMLData -Path 'D:\EMF\MyOwnEmfConfig.xml'
```

In this example we explicit tell the cmdlet to validate a configuration file in a custom location.

## PARAMETERS

### -EMFHome

Path to root directory for EasitManagementFramework.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Home

Required: False
Position: 0
Default value: $Home\EMF
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Full path to the configuration file you would like to validate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $EMFHome\emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaFile

Full path to schema that you would like to validate against.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $EMFHome\emfConfig.xsd
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateSettings
{{ Fill ValidateSettings Description }}

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
