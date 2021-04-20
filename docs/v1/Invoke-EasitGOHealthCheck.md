---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Invoke-EasitGOHealthCheck.md
schema: 2.0.0
---

# Invoke-EasitGOHealthCheck

## SYNOPSIS

Cmdlet to get "health details" of server and the Easit application.

## SYNTAX

```powershell
Invoke-EasitGOHealthCheck [[-EmfHome] <String>] [[-EmfConfigurationFileName] <String>]
 [-EmfConfigurationName] <String> [<CommonParameters>]
```

## DESCRIPTION

This cmdlet provide details such as free system memory, free drive space, if the Easit service is runnning and if the application can be connected to. The cmdlet do not present any evaluation if the result is good or bad. The cmdlet provides detailed that can be used in an evaluation if the setup is correct or not.

## EXAMPLES

### Example 1

```powershell
PS C:\> Invoke-EasitGOHealthCheck -system 'prod'
```

Get health details for a system / application called prod in the configuration file for EMF. 

## PARAMETERS

### -EmfConfigurationFileName

Name of the configuration file to use.

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

### -EmfConfigurationName

Name of configuration to use in the configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: system

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfHome

Path to root directory for EasitManagementFramework.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-EasitGOHealthCheck.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-EasitGOHealthCheck.md)

