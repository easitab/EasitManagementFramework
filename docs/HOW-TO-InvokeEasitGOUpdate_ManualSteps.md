# Invoke-EasitGOUpdate - Manual steps

## Stop scheduled tasks

```powershell
Get-EasitScheduledTask
```
Then run the following command for each task you would like to disable.

```powershell
Disable-EasitScheduledTask -TaskName 'NameOfTaskToDisable'
```

## Stop service

```powershell
Stop-EasitGOApplication -EmfConfigurationName 'NameOfApplicationToStop'
```

## Backup database

Perform a backup database for the application.

## Backup files and folder

Copy the following files and folders specified in emfConfig.xml:

- *SystemRoot*\config (zip whole folder and move zip to *BackupRoot*)

- *SystemRoot*\logs (zip whole folder and move zip to *BackupRoot*, then delete contents of *SystemRoot*\logs)

- *TomcatRoot*\\*WarName* (move to *BackupRoot* and delete everything named *WarName* in *TomcatRoot*)

Copy the files and folders to *BackupRoot* specified in emfConfig.xml.

## Replace files

Copy war file in *UpdateResourceDirectory* to *TomcatRoot* and rename it to *WarName*.

## Start service

```powershell
Start-EasitGOApplication -EmfConfigurationName 'NameOfApplicationToStop'
```

## Connect to Easit GO

Open your prefered web browser connecto to Easit GO.