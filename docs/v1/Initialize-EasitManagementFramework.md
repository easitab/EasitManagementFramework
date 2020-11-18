---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Initialize-EasitManagementFramework.md
schema: 2.0.0
---

# Initialize-EasitManagementFramework

## SYNOPSIS
Initialize EasitManagementFramework with template files.

## SYNTAX

```
Initialize-EasitManagementFramework [[-EMFHome] <String>] [[-ConfigURL] <String>] [[-SchemaURL] <String>]
 [[-ConfigName] <String>] [[-SchemaName] <String>] [<CommonParameters>]
```

## DESCRIPTION
The *Initialize-EasitManagementFramework* cmdlet helps you get started with using the framework. It will download template configuration file and schema file from the github project for you to *C:\Users\currentuser\EMF*.

## EXAMPLES

### Example 1
```powershell
PS C:\> Initialize-EasitManagementFramework
```

Download template files from the github project.

### Example 2
```powershell
PS C:\> Initialize-EasitManagementFramework -EMFHome 'D:\customPath\to\EMF'
```

Download template files from the github project to a custom folder.

## PARAMETERS

### -ConfigName
File name of downloaded configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigURL
URL to download configuration file from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/configurations/emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -EMFHome
Root folder of EMF. This is where the cmdlet will download files to.

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

### -SchemaName
File name of downloaded schema file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: emfConfig.xsd
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaURL
URL to download schema file from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/schemas/emfConfig.xsd
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
=======
---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/Initialize-EasitManagementFramework.md
schema: 2.0.0
---

# Initialize-EasitManagementFramework

## SYNOPSIS
Initialize EasitManagementFramework with template files.

## SYNTAX

```
Initialize-EasitManagementFramework [[-EMFHome] <String>] [[-ConfigURL] <String>] [[-SchemaURL] <String>]
 [[-ConfigName] <String>] [[-SchemaName] <String>] [<CommonParameters>]
```

## DESCRIPTION
The *Initialize-EasitManagementFramework* cmdlet helps you get started with using the framework. It will download template configuration file and schema file from the github project for you to *C:\Users\currentuser\EMF*.

## EXAMPLES

### Example 1
```powershell
PS C:\> Initialize-EasitManagementFramework
```

Download template files from the github project.

### Example 2
```powershell
PS C:\> Initialize-EasitManagementFramework -EMFHome 'D:\customPath\to\EMF'
```

Download template files from the github project to a custom folder.

## PARAMETERS

### -ConfigName
File name of downloaded configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigURL
URL to download configuration file from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/configurations/emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -EMFHome
Root folder of EMF. This is where the cmdlet will download files to.

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

### -SchemaName
File name of downloaded schema file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: emfConfig.xsd
Accept pipeline input: False
Accept wildcard characters: False
```

### -SchemaURL
URL to download schema file from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/schemas/emfConfig.xsd
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