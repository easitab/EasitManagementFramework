---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EMFConfig.md
schema: 2.0.0
---

# Get-EMFConfig

## SYNOPSIS

Gets the configuration for one system.

## SYNTAX

```
Get-EMFConfig [-EMFHome <String>] [-EmfConfigurationFileName <String>] [-EmfConfigurationName] <String>
 [<CommonParameters>]
```

## DESCRIPTION

Gets the configuration for one system from the configuration file. You need to specify what system you would like to get the configuration for.
The *Get-EMFConfig* cmdlet does not support array input.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-EMFConfig -ConfigurationName Test
```

Get the configuration for a system called Test.

### Example 2

```powershell
PS C:\> $systems = 'Test', 'Dev'
PS C:\> $systems | ForEach-Object {Get-EMFConfig -ConfigurationName $PSItem }
```

Get the configuration for each system in the array systems.

## PARAMETERS

### -EmfConfigurationFileName
{{ Fill EmfConfigurationFileName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: ConfigurationFileName, ConfigFile, ConfigFileName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationName
{{ Fill EmfConfigurationName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: ConfigurationName, ConfigName

Required: True
Position: 0
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
Position: Named
Default value: ${env:ALLUSERSPROFILE}\EMF
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
