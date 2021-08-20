---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-DatabaseDetails.md
schema: 2.0.0
---

# Get-DatabaseDetails

## SYNOPSIS

Private function used to split dataSource.url from properties.xml

## SYNTAX

```powershell
Get-DatabaseDetails [-Uri] <String> [<CommonParameters>]
```

## DESCRIPTION

Splits / Parses an url into dbName, dbServerName, dbPort, dbInstance.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-DatabaseDetails -Uri 'jdbc:sqlserver://serverUrl:port\\instanceName;databaseName=nameOfDatabase'

dbServerName dbServerPort dbInstance   dbName
------------ ------------ ----------   ------
serverUrl    port         instanceName nameOfDatabase
```

## PARAMETERS

### -Uri

String to parse / split

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
