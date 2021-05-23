---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Set-EMFConfig.md
schema: 2.0.0
---

# Set-EMFConfig

## SYNOPSIS

Update or set property for existing configuration.

## SYNTAX

### Manual
```
Set-EMFConfig [-EMFHome <String>] [-ConfigurationFileName <String>] [-ConfigurationName] <String>
 -EasitRoot <String> [-SystemRoot <String>] [-ServiceName <String>] [-WarName <String>] [-TomcatRoot <String>]
 [-BackupRoot <String>] [-EmailRequestRoot <String>] [-ImportClientRoot <String>]
 [-UpdateResourceDirectory <String>] [-StoredBackupProcedure <String>] [-ValidateSettings] [<CommonParameters>]
```

### Array
```
Set-EMFConfig [-EMFHome <String>] [-ConfigurationFileName <String>] [-ConfigurationName] <String>
 -PropertySetting <String[]> [-ValidateSettings] [<CommonParameters>]
```

## DESCRIPTION

The *Set-EMFConfig* cmdlet lets you set the value for one or more properties in a existing configuration and add one or more properties for a existing configuration. If you pass in an array of properties and one of those properties does not exist the cmdlet will add it for you. If the configuration doesn't exist you will get an error.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-EMFConfig -ConfigurationName 'Dev' -EasitRoot 'E:\Easit'
```

In this example we update the settings for a configuration named Dev. Since the value from EasitRoot is inherited by all other parameters in the parameter set, e.g. SystemRoot in this case becomes E:\Easit\Systems\Dev and TomcatRoot in this becomes E:\Easit\Tomcat\Dev. This principle can be overridden by explicit providing a value for the parameter.

### Example 2

```powershell
PS C:\> Set-EMFConfig -ConfigurationName 'Dev' -EasitRoot 'E:\Easit' -TomcatRoot 'F:\Tomcat\Dev'
```

In this example we update the settings for a configuration named Dev and overriding the inheritance principle by explicit telling the cmdlet that the value for *TomcatRoot* is *F:\Tomcat\Dev*.

### Example 3

```powershell
PS C:\> $PropertySettings = "EasitRoot, E:\Easit", "TomcatRoot, F:\Tomcat\Dev", "BackupRoot, D:\Easit\_Backup"
PS C:\> Set-EMFConfig -ConfigurationName 'Dev' -PropertySettings $PropertySettings
```

In this example we update the settings for a configuration named Dev by providing an array with property names and values.

## PARAMETERS

### -BackupRoot

Path to directory to use for backups of EmailRequest and Tomcat settings 

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: $EasitRoot\_Backup\$ConfigurationName
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationFileName

Name of the configuration file to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases: file, filename

Required: False
Position: Named
Default value: emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigurationName

Name of configuration to use in the configuration file.

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

Path to Easit directory which usually contains EmailRequest, ImportClient, Tomcat, Java and so on.

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

Path to root directory for EmailRequest.

```yaml
Type: String
Parameter Sets: Manual
Aliases: ER, EmailRequest, erRoot

Required: False
Position: Named
Default value: $EasitRoot\EmailRequest
Accept pipeline input: False
Accept wildcard characters: False
```

### -EMFHome

Path to root directory for EasitManagementFramework.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Home

Required: False
Position: Named
Default value: $Home\EMF
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportClientRoot

Path to root directory for ImportClient.

```yaml
Type: String
Parameter Sets: Manual
Aliases: IC, ImportClient, icRoot

Required: False
Position: Named
Default value: $EasitRoot\ImportClient
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertySetting

Array of properties and values to set in a configuration.

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

DisplayName of the Windows service installed by Apache Tomcat that starts and stops Easit BPS / GO.

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: Easit$ConfigurationName
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoredBackupProcedure
{{ Fill StoredBackupProcedure Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases: sbp

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemRoot

Path to the systems configuration directory.

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: $EasitRoot\Systems\$ConfigurationName
Accept pipeline input: False
Accept wildcard characters: False
```

### -TomcatRoot

Path to systems Tomcat root directory.

```yaml
Type: String
Parameter Sets: Manual
Aliases:

Required: False
Position: Named
Default value: $EasitRoot\Tomcat\$ConfigurationName
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateResourceDirectory
{{ Fill UpdateResourceDirectory Description }}

```yaml
Type: String
Parameter Sets: Manual
Aliases: urd

Required: False
Position: Named
Default value: None
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

### -WarName
{{ Fill WarName Description }}

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
