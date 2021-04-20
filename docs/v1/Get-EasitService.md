---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EasitService.md
schema: 2.0.0
---

# Get-EasitService

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```powershell
Get-EasitService [-ServiceName] <String> [<CommonParameters>]
```

## DESCRIPTION

Cmdlet to find a service with a name like the the string passed to cmdlet with -ServiceName parameter. Executed command to find service: ``Get-CimInstance -ClassName Win32_Service -Filter "Name Like '$ServiceName'"``

## EXAMPLES

### Example 1

```powershell
PS C:\> $easitGoServiceName = 'EasitProd'
PS C:\> Get-EasitService -ServiceName "$easitGoServiceName"
```

## PARAMETERS

### -ServiceName

Name of service to find.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
