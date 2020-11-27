---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Import-EMFXMLData.md
schema: 2.0.0
---

# Import-EMFXMLData

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```
Import-EMFXMLData [-Path] <String> [-Validate] [<CommonParameters>]
```

## DESCRIPTION

Import XML file and return an XML object.

## EXAMPLES

### Example 1

```powershell
PS C:\> $EMFHome = "$Home\EMF"
PS C:\> $ConfigurationFileName = 'emfConfig.xml'
PS C:\> Import-EMFXMLData -Path "$EMFHome\$ConfigurationFileName"
```

## PARAMETERS

### -Path

Path to XML-file to import and return.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Validate

Switch to use if validation should be performed against schema file. If the parameter is stated the *Import-EMFXMLData* will invoke this command: *Test-EMFXMLData -Path $Path*

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
