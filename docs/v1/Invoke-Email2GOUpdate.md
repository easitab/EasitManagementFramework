---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Invoke-Email2GOUpdate.md
schema: 2.0.0
---

# Invoke-Email2GOUpdate

## SYNOPSIS

Update patch level of Email2GO.

## SYNTAX

```powershell
Invoke-Email2GOUpdate [[-EmfHome] <String>] [[-EmfConfigurationFileName] <String>]
 [[-EmfConfigurationName] <String>] [[-UpdateResourceDirectory] <String>] [-UpdateFilename] <String>
 [-RunningElevated] [-Cleanup] [<CommonParameters>]
```

## DESCRIPTION

This cmdlet lets to update the patch level of Email2GO in a structured and automatic way. By default the cmdlet looks for a file with the name passed in as -UpdateFilename in a folder called Update located in EasitRoot. The cmdlet will try to backup the database for Easit GO by executing a stored procedure named like the value passed in as -StoredProcedureName.
If -SkipDbBackup parameter is stated the cmdlet assumes you already have performed a backup of the database.

## EXAMPLES

### Example 1

```powershell
PS C:\> Invoke-Email2GOUpdate -UpdateFilename 'email2GO-patch-1.2.zip' -RunningElevated
```

In this example we will update Email2GO with the file email2GO-patch-1.2.zip. By providing RunningElevated we let the cmdlet know that we have the correct privileges. If the RunningElevated parameter is omitted the cmdlet will throw an error like 'Session is not running with elevated priviliges that is need to perfom this action'.

## PARAMETERS

### -Cleanup

Used if the cmdlet should try to remove folders or files no longer needed when update is completed.

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

### -EmfConfigurationFileName

Name of the configuration file to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmfConfigurationName

Name of configuration to use in the configuration file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunningElevated

Fail safe swith to avoid running the cmdlet by misstake or with wrong priviliges.

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

### -UpdateFilename

Name of file to use for updating Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateResourceDirectory

Used if a custom or other location than the directory 'Update' in EasitRoot should be used to find file to update Easit GO with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-Email2GOUpdate.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-Email2GOUpdate.md)

