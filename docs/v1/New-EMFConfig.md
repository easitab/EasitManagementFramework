---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/New-EMFConfig.md
schema: 2.0.0
---

# New-EMFConfig

## SYNOPSIS

Create a new configuration for EMF.

## SYNTAX

```
New-EMFConfig [[-EMFHome] <String>] [[-ConfigurationFileName] <String>] [-ConfigurationName] <String>
 [-ConfigurationSettings] <Hashtable> [-Validate] [[-SchemaFile] <String>] [<CommonParameters>]
```

## DESCRIPTION

The *New-EMFConfig* cmdlet lets you create a new configuration within an already existing configuration file. If an configuration file does not already exist, one will be created by the cmdlet. If the configuration name is already used in the configuration file you will get a warning and the cmdlet stops.

```xml
<systems>
  <Prod>
    <SystemRoot>D:\Easit\Systems\Prod</SystemRoot>
    <ServiceName>EasitProd</ServiceName>
    <EasitRoot>D:\Easit</EasitRoot>
    <BackupRoot>D:\Easit\_Backup\Prod</BackupRoot>
    <TomcatRoot>D:\Easit\Tomcat\Prod</TomcatRoot>
    <EmailRequestRoot>D:\Easit\EmailRequest</EmailRequestRoot>
    <ImportClientRoot>D:\Easit\ImportClient</ImportClientRoot>
  </Prod>
<systems>
```

## EXAMPLES

### Example 1

```powershell
PS C:\> $hashtable = @{SystemRoot = D:\Easit\Systems\Test;ServiceName = EasitTest}
PS C:\> New-EMFConfig -ConfigurationName Test -ConfigurationSettings $hastable
```

In this example we first create a hastable with all the properties and its values for the configuration (*ConfigurationName*) we would like to add. We name the configuration with the parameter *ConfigurationName* and pass the hashtable in with the parameter *ConfigurationSettings*.
This will create a configuration named Test with two (*SystemRoot* and *ServiceName*) properties.

```xml
<systems>
  <Test>
    <SystemRoot>D:\Easit\Systems\Prod</SystemRoot>
    <ServiceName>EasitProd</ServiceName>
  </Test>
<systems>
```

## PARAMETERS

### -ConfigurationFileName

Name of the configuration file to use.

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

Name of configuration to use in the configuration file.

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

Hashtable with properties and its values that the configuration should have.

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

### -SchemaFile

Full path, including file and extension, to use when validating configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $EMFHome\emfConfig.xsd
Accept pipeline input: False
Accept wildcard characters: False
```

### -Validate

Switch to use if you would like to validate configuration file.

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
