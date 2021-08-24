---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Invoke-EasitGOUpdate.md
schema: 2.0.0
---

# Invoke-EasitGOUpdate

## SYNOPSIS

Update patch level of Easit GO.

## SYNTAX

```
Invoke-EasitGOUpdate [[-EmfHome] <String>] [[-EmfConfigurationFileName] <String>]
 [[-EmfConfigurationName] <String>] [[-UpdateResourceDirectory] <String>] [-UpdateFilename] <String>
 [-RunningElevated] [-SkipDbBackup] [-StoredProcedureName] [<CommonParameters>]
```

## DESCRIPTION

This cmdlet lets to update the patch level of Easit GO in a structured and automatic way. By default the cmdlet looks for a file with the name passed in as -UpdateFilename in a folder called Update located in EasitRoot.

Manual steps for updating Easit GO, if this function failes for some reasing, can be found here: [HOW-TO-InvokeEasitGOUpdate_ManualSteps](https://github.com/easitab/EasitManagementFramework/blob/development/docs/HOW-TO-InvokeEasitGOUpdate_ManualSteps.md)

## EXAMPLES

### Example 1

```powershell
PS C:\> Invoke-EasitGOUpdate -EmfConfigurationName 'test' -UpdateFilename 'bpe-2021.05.1.war' -RunningElevated -StoredProcedureName 'EasitBackupProcedure'
```

In this example we will update Easit GO "test" with the file bpe-2021.05.1.war. By providing RunningElevated we let the cmdlet know that we have the correct privileges. If the RunningElevated parameter is omitted the cmdlet will throw an error like 'Session is not running with elevated priviliges that is need to perfom this action'.

### Example 2

```powershell
PS C:\> Invoke-EasitGOUpdate -UpdateFilename 'bpe-2021.05.1.war' -RunningElevated -SkipDbBackup
```

As we have omitted EmfConfigurationName the cmdlet defaults to "dev" and we have already done a backup of the database.

### Example 3

```powershell
PS C:\> Invoke-EasitGOUpdate -EmfConfigurationName 'prod' -UpdateFilename 'bpe-2021.05.1.war' -RunningElevated -StoredProcedureName 'EasitBackupProcedure'
```

In this example we will update Easit GO "prod" with the file bpe-2021.05.1.war. By providing RunningElevated we let the cmdlet know that we have the correct privileges. A backup of the database will be perfomed with the stored procedure named *EasitBackupProcedure*.

## PARAMETERS

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

### -SkipDbBackup

Tells the cmdlet know if it should skip taking backup of the database.

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

### -StoredProcedureName

Name of stored procedure to use in order to perform backup of database.

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

[https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-EasitGOUpdate.md](https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Invoke-EasitGOUpdate.md)

