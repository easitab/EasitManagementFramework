---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Remove-CertificateFromEasitTrustStore.md
schema: 2.0.0
---

# Remove-CertificateFromEasitTrustStore

## SYNOPSIS

Removes a certificate from a truststore.

## SYNTAX

### LiteralPath
```
Remove-CertificateFromEasitTrustStore -LiteralPath <String> [-Keytool <String>] -StorePass <String>
 -CertificateAlias <String> [-EmfHome <String>] [-EmfConfigurationFileName <String>]
 [-EmfConfigurationName <String>] [<CommonParameters>]
```

### Path
```
Remove-CertificateFromEasitTrustStore [-Path <String>] -TrustStoreName <String> [-Keytool <String>]
 -StorePass <String> -CertificateAlias <String> [-EmfHome <String>] [-EmfConfigurationFileName <String>]
 [-EmfConfigurationName <String>] [<CommonParameters>]
```

## DESCRIPTION

The *Remove-CertificateFromEasitTrustStore* cmdlet let you remove a certificate from a truststore. The cmdlet executes keytool.exe with a combination of switches and inputs based on the input to this cmdlet and displays its output.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-CertificateFromEasitTrustStore -Path 'D:\Easit\TrustStore\' -TrustStoreName 'CompanyTruststore.jks' -CertificateAlias 'OurCert' -StorePass 'TrustStorePassword'
```

Removes a certificate from a truststore using the Path and TrustStoreName parameters.

## PARAMETERS

### -CertificateAlias

The alias given to the certificate in the truststore.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationFileName

Name of the configuration file to use.

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

Name of configuration to use in the configuration file.

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

Path to root directory for EasitManagementFramework.

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

Full path to the keytool to use when managing the truststore.

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

Full path to truststore.

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

Path to folder where the truststore is located.

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

Truststore password.

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

Name of the truststore.

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

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Remove-CertificateFromEasitTrustStore.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Remove-CertificateFromEasitTrustStore.md)

