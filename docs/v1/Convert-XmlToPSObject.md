---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Convert-XmlToPSObject.md
schema: 2.0.0
---

# Convert-XmlToPSObject

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```
Convert-XmlToPSObject [-XmlObject] <XmlDocument> [-SystemProperties] [<CommonParameters>]
```

## DESCRIPTION

Generic cmdlet to convert XML-files to PSObjects. Only supports formatting like properties.xml at the moment.

## EXAMPLES

### Example 1
```powershell
PS C:\> $xmlObject = New-Object System.Xml.XmlDocument
PS C:\> $xmlObject.Load('D:\Easit\Systems\Prod\config\properties.xml')
PS C:\> Convert-XmlToPSObject -XmlObject $xml -SystemProperties
```

In this example we would like to convert properties.xml to a PSObject.

## PARAMETERS

### -SystemProperties

Tells the cmdlet that the file to convert have a certain formatting.

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

### -XmlObject

XMLObject to convert.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
