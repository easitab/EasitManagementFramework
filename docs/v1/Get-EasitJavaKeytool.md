---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EasitJavaKeyTool.md
schema: 2.0.0
---

# Get-EasitJavaKeytool

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```powershell
Get-EasitJavaKeytool [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

Finds keytool.exe and returns it via Get-ChildItem. Cmdlet adds Java to the path before executing Get-ChildItem.

## EXAMPLES

### Example 1

```powershell
PS C:\> $Keytool = Get-EasitJavaKeytool -Path $emfConfig.EasitRoot
```

This will look for keytool.exe in $emfConfig.EasitRoot and if it finds it returns it.

## PARAMETERS

### -Path

Path to look for keytool.exe recursively in.

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
