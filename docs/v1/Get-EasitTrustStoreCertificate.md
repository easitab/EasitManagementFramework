---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EasitTrustStoreCertificate.md
schema: 2.0.0
---

# Get-EasitTrustStoreCertificate

## SYNOPSIS

Cmdlet to get a or all certificate in the truststore.

## SYNTAX

### LiteralPath

```powershell
Get-EasitTrustStoreCertificate -LiteralPath <String> [-Keytool <String>] -StorePass <String>
 [-CertificateAlias <String>] [-EmfHome <String>] [-EmfConfigurationFileName <String>]
 [-EmfConfigurationName <String>] [<CommonParameters>]
```

### Path

```powershell
Get-EasitTrustStoreCertificate [-Path <String>] -TrustStoreName <String> [-Keytool <String>]
 -StorePass <String> [-CertificateAlias <String>] [-EmfHome <String>] [-EmfConfigurationFileName <String>]
 [-EmfConfigurationName <String>] [<CommonParameters>]
```

## DESCRIPTION

With this cmdlet you can look at all or one certificate in the truststore to see information like when it expires and issuer. If no alias is provided all certificates and a count of total certificates present in truststore is returned.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-EasitTrustStoreCertificate -LiteralPath 'C:\Certs\EasitTrustStore.jks' -StorePass "$PasswordToTruststore"
```

In this example we want to get all certificates in the truststore.

### Example 2

```powershell
PS C:\> Get-EasitTrustStoreCertificate -LiteralPath 'C:\Certs\EasitTrustStore.jks' -CertificateAlias 'MyCert' -StorePass "$PasswordToTruststore"
```

In this example we want to get a certificate with the alias *MyCert* from the truststore.

## PARAMETERS

### -CertificateAlias

Alias for the certificate. This is set when the certificate is imported to the truststore.

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

Full path to keytool.exe that should be used to interact with the truststore.

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

Path to directory that the truststore is located in.

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

Password to the truststore.

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

Name of the truststore. For example, EasitTruststore.jks

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
