---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Set-EasitEmailRequestMailboxSetting.md
schema: 2.0.0
---

# Set-EasitEmailRequestMailboxSetting

## SYNOPSIS

Used to update / change settings for a "mailbox" used by EmailRequest.

## SYNTAX

```
Set-EasitEmailRequestMailboxSetting [[-EmfHome] <String>] [[-EmfConfigurationFileName] <String>]
 [[-EmfConfigurationName] <String>] [[-EmailRequestConfigurationFilename] <String>] [-MailboxName] <String>
 [-SettingName] <String> [-SettingValue] <String> [<CommonParameters>]
```

## DESCRIPTION

With this cmdlet you can update one setting for an "mailbox" in the configuration file for EmailRequest.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-EasitEmailRequestMailboxSetting -MailboxName 'POP3Test' -SettingName 'disabled' -SettingValue 'false'
```

This example shows you how to enables a mailbox with the displayName *POP3Test*.

### Example 2

```powershell
PS C:\> Set-EasitEmailRequestMailboxSetting -MailboxName 'POP3Test' -SettingName 'maxMessageSize' -SettingValue '12582912'
```

In this example the setting *maxMessageSize* for *POP3Test* is set to *12582912*. The value for *maxMessageSize* should be provided in bytes in the case of POP3 and kilobytes in the case of IMAP4.

### Example 3

```powershell
PS C:\> Set-EasitEmailRequestMailboxSetting -MailboxName 'POP3Test' -SettingName 'maxMessagesToRetrieve' -SettingValue '20'
```

In this example the setting *maxMessagesToRetrieve* for *POP3Test* is set to *20*. This allows you to set how many unread mail EmailRequest should try to import from the mailbox.

## PARAMETERS

### -EmailRequestConfigurationFilename

Name of configuration file for EmailReques to update.

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

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingName

Name of parameter to update in EmailRequest configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingValue

New value you would like to give to a parameter in EmailRequest configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Value

Required: True
Position: 6
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
