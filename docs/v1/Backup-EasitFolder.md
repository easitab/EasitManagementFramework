---
external help file: EasitManagementFramework-help.xml
Module Name: EasitManagementFramework
online version: https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Backup-EasitFolder.md
schema: 2.0.0
---

# Backup-EasitFolder

## SYNOPSIS

Private cmdlet, not used by user directly.

## SYNTAX

```
Backup-EasitFolder [-FolderToBackup] <String> [-DestinationFolder] <String> [[-ArchiveName] <String>]
 [[-Cleanup] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION

Compresses provided folder or file to a archive and moves it to a specified location. If used with the parameter -Cleanup the provided folder to create archive with will be removed.

## EXAMPLES

### Example 1

```powershell
PS C:\> $folder = 'D:\Easit\Systems\Prod\conf'
PS C:\> $backupRoot = 'D:\Easit\_backup'
PS C:\> Backup-EasitFolder -FolderToBackup "$folder" -DestinationFolder $backupRoot
```

This will create a zipfile with the contents of *D:\Easit\Systems\Prod\conf* named conf_todaysdateincludingminuteandseconds.zip in *``D:\Easit\_backup\todaysdate\``*

## PARAMETERS

### -ArchiveName

Used if a custom name for the zipfile should be used.

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

### -Cleanup

Used if the cmdlet should try to remove folder or file provided via parameter FolderToBackup.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationFolder

Path to folder where the zipfile should be saved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderToBackup

File or folder to *backup*.

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
