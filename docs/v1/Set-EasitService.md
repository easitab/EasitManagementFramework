---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Set-EasitService.md
schema: 2.0.0
---

# Set-EasitService

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```
Set-EasitService [-Service] <CimInstance> [-Action] <String> [<CommonParameters>]
```

## DESCRIPTION

Cmdlet to invoke methods to CimInstance (Win32_Process).

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-EasitService -Service $easitGoService -Action 'StartService'
```

In this example we attempt to start a service.

### Example 2

```powershell
PS C:\> Set-EasitService -Service $easitGoService -Action 'StopService'
```

In this example we attempt to stop a service.

## PARAMETERS

### -Action

Method to invoke for the CimInstance / service.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: StartService, StopService

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Service

Service to invoke method on.

```yaml
Type: CimInstance
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
