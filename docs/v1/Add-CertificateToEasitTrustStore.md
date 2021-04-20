---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Add-CertificateToEasitTrustStore.md
schema: 2.0.0
---

# Add-CertificateToEasitTrustStore

## SYNOPSIS
Add a certificate to a truststore.

## SYNTAX

### LiteralPath
```
Add-CertificateToEasitTrustStore -LiteralPath <String> -Certificate <String> [-Keytool <String>]
 -StorePass <String> -CertificateAlias <String> [-TrustCaCerts] [-NoPrompt] [-EmfHome <String>]
 [-EmfConfigurationFileName <String>] [-EmfConfigurationName <String>] [<CommonParameters>]
```

### Path
```
Add-CertificateToEasitTrustStore [-Path <String>] -TrustStoreName <String> -Certificate <String>
 [-Keytool <String>] -StorePass <String> -CertificateAlias <String> [-TrustCaCerts] [-NoPrompt]
 [-EmfHome <String>] [-EmfConfigurationFileName <String>] [-EmfConfigurationName <String>] [<CommonParameters>]
```

## DESCRIPTION
The *Add-CertificateToEasitTrustStore* cmdlet let you add a certificate to a truststore. If the truststore does not exist it will be created. The cmdlet executes keytool.exe with a combination of switches and inputs based on the input to this cmdlet and displays its output.

## EXAMPLES

### Example 1

```powershell
PS C:\> Add-CertificateToEasitTrustStore -Path 'D:\Easit\TrustStore\' -TrustStoreName 'CompanyTruststore.jks' -Certificate 'D:\certs\ourCert.crt' -CertificateAlias 'OurCert' -StorePass 'TrustStorePassword'
```

Adds a certificate to a truststore using the Path and TrustStoreName parameters.

### Example 2

```powershell
PS C:\> Add-CertificateToEasitTrustStore -LiteralPath 'D:\Easit\TrustStore\CompanyTruststore.jks' -Certificate 'D:\certs\ourCert.crt' -CertificateAlias 'OurCert' -StorePass 'TrustStorePassword'
```

Adds a certificate to a truststore using the LiteralPath parameter.

### Example 3

```powershell
PS C:\> Add-CertificateToEasitTrustStore -LiteralPath 'D:\Easit\TrustStore\CompanyTruststore.jks' -Certificate 'D:\certs\ourCert.crt' -CertificateAlias 'OurCert' -StorePass 'TrustStorePassword' -NoPrompt
```

Adds a certificate to a truststore useing the LiteralPath parameter and suppress all prompts.

## PARAMETERS

### -Certificate

Full path to certificate that should be imported / added to the truststore.

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

### -CertificateAlias

The alias given to the certificate in the truststore. This can be used to look up certificate details in the truststore at a later point in time.

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

### -NoPrompt

Suppress all prompts from the keytool executable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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

### -TrustCaCerts

Trust certificates from cacerts.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
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

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Add-CertificateToEasitTrustStore.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Add-CertificateToEasitTrustStore.md)

