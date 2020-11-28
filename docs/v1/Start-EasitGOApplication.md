---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Start-EasitGOApplication.md
schema: 2.0.0
---

# Start-EasitGOApplication

## SYNOPSIS

Starts an Easit GO application on the local machine.

## SYNTAX

```
Start-EasitGOApplication [[-EmfHome] <String>] [[-EmfConfigurationFileName] <String>]
 [[-EmfConfigurationName] <String>] [-Verify] [<CommonParameters>]
```

## DESCRIPTION

The *Start-EasitGoApplication* cmdlet starts an Easit GO application on the local machine by querying for a Cim instance with a name like specified in the EMF configuration file.

## EXAMPLES

### Example 1

```powershell
PS C:\> Start-EasitGOApplication
```

In this example the cmdlet uses its default values and tries to start the application.

### Example 2

```powershell
PS C:\> Start-EasitGOApplication -EmfConfigurationName 'Prod'
```

In this example the cmdlet will try to start the application with a service name specified in the configuration block named *Prod* in *emfConfig.xml* in *EMFHome*.

### Example 3

```powershell
PS C:\> Start-EasitGOApplication -EmfConfigurationFileName 'emf_prod_config.xml'
```

In this example the cmdlet will try to start the application with a service name specified in the in *emf_prod_config.xml* in *EMFHome*.

### Example 4

```powershell
PS C:\> Start-EasitGOApplication -EmfHome 'C:\Users\localAdmin\EMF'
```

In this example the cmdlet will try to start the application with a service name specified in the in *emfConfig.xml* in *C:\Users\localAdmin\EMF*. This example can be used if you have your configuration files located in another place then *$Home/EMF*.

## PARAMETERS

### -EmfConfigurationFileName

Name of EasitManagementFramework configuration file to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: emfConfig.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationName

Name of configuration to use in EasitManagementFramework configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Prod
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
Default value: $Home\EMF
Accept pipeline input: False
Accept wildcard characters: False
```

### -Verify

Use the *Verify* parameter to verify that the application can be reached in a browser.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $false
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### CIM Instance

## NOTES

## RELATED LINKS
