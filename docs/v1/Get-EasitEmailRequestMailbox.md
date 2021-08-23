---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Get-EasitEmailRequestMailbox.md
schema: 2.0.0
---

# Get-EasitEmailRequestMailbox

## SYNOPSIS

Gets the configuration settings for one or all mailboxes configured for EmailRequest.

## SYNTAX

```
Get-EasitEmailRequestMailbox [[-EmfHome] <String>] [[-EmfConfigurationFileName] <String>]
 [[-EmfConfigurationName] <String>] [[-EmailRequestConfigurationFilename] <String>] [[-MailboxName] <String>]
 [<CommonParameters>]
```

## DESCRIPTION

The *Get-EasitEmailRequestMailbox* cmdlet gets all settings for one or all mailboxed configured for EmailRequest. The cmdlet does not return the password for any mailbox for security reasons.

In order to find the correct configuration file for EmailRequest the cmdlet uses recursive search.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-EasitEmailRequestMailbox
```

In this example we will get all mailboxes configured for EmailRequest.

### Example 2

```powershell
PS C:\> Get-EasitEmailRequestMailbox -EmailRequestConfigurationFilename '*config*.xml' | Out-GridView
```

This example will return all mailboxes from all files with xml files that have a name containing config and display them in a grid view.

### Example 2

```powershell
PS C:\> Get-EasitEmailRequestMailbox -EmailRequestConfigurationFilename 'config_prod.xml' -MailboxName '*prod*' | Out-GridView
```

This example will return all mailboxes with a displayName containing the word *prod* from the configuration file named *config_prod.xml* and display them in a grid view.

## PARAMETERS

### -EmailRequestConfigurationFilename

Name of configuration file to find mailboxes in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: config.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationFileName

Name of EasitManagementFramework configuration file to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: config.xml
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
Default value: ${env:ALLUSERSPROFILE}\EMF
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailboxName

Name of mailbox to update setting for. Same as displayName in EmailRequest configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Mailbox

Required: False
Position: 4
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
