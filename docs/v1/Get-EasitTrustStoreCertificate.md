---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EasitTrustStoreCertificate.md
schema: 2.0.0
---

# Get-EasitTrustStoreCertificate

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### LiteralPath
```
Get-EasitTrustStoreCertificate -LiteralPath <String> [-Keytool <String>] -StorePass <String>
 [-CertificateAlias <String>] [-EmfHome <String>] [-EmfConfigurationFileName <String>]
 [-EmfConfigurationName <String>] [<CommonParameters>]
```

### Path
```
Get-EasitTrustStoreCertificate [-Path <String>] -TrustStoreName <String> [-Keytool <String>]
 -StorePass <String> [-CertificateAlias <String>] [-EmfHome <String>] [-EmfConfigurationFileName <String>]
 [-EmfConfigurationName <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -CertificateAlias
{{ Fill CertificateAlias Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationFileName
{{ Fill EmfConfigurationFileName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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
Aliases: system

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfHome
{{ Fill EmfHome Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Keytool
{{ Fill Keytool Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LiteralPath
{{ Fill LiteralPath Description }}

```yaml
Type: String
Parameter Sets: LiteralPath
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StorePass
{{ Fill StorePass Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: keystorepass, truststorepass

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TrustStoreName
{{ Fill TrustStoreName Description }}

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
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