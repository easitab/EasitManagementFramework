---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/Get-EasitEmailRequestMailbox.md
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
PS C:\> Get-EasitEmailRequestMailbox -MailboxName POP3Test
```

In this example we will get all settings for a mailbox with *POP3Test* as its displayName.

### Example 3
```powershell
PS C:\> Get-EasitEmailRequestMailbox -MailboxName POP3Test -EmfConfigurationName Test
```

In this example we will get all settings for a mailbox with *POP3Test* as its displayName in config.xml in the folder provided in EmailRequestRoot for EMF-configuration Test.

### Example 4
```powershell
PS C:\> Get-EasitEmailRequestMailbox -MailboxName POP3Test -EmailRequestConfigurationFilename config_test.xml
```

In this example we will get all settings for a mailbox with *POP3Test* as its displayName in config_test.xml. Use this syntax if you have multiple configurationfiles for EmailRequest.

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
Default value: $Home\EMF
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
