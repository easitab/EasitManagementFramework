# How to test Easit Management Framework

## Prerequisites

- User account with administrative privileges on server where Easit GO is installed.
- Windows Powershell 5.1 installed on server where Easit GO is installed.
- Execution Policy for Windows Powershell set to Unrestricted or Bypass on server where Easit GO is installed for the user account that will do the testing.
- Access and privilege to perform backup of Easit GO's database or a configuration in place that allows the user account to execute stored procedures on SQL-server.
- Please uninstall any version of EasitManagementFramework previously installed (Uninstall-Module EasitManagementFramework & Remove-Module EasitManagementFramework).

## Testing structure

Every test or series of tests should be started with and stopped with the corresponding *start* and *stop* command specified bellow.
If you get an error when executing any of the tests, please add -Verbose at the end and rerun the command that gave you the error.
Regardles if your test fails or not, please report back by creating an issue with the file created by Start-Transcript attached (or send an email to github(AT)easit.com).

### Start

```powershell
Start-Transcript -Path "$Home\CustomerName_date_[functionOrSession].log"
```

### Stop

```powershell
Stop-Transcript
```

### Example 1

```powershell
Start-Transcript -Path "$Home\EasitAB_20210412_init.log"
Initialize-EasitManagementFramework
Stop-Transcript
```

### Example 2

```powershell
Start-Transcript -Path "$Home\EasitAB_20210412_session1.log"
Initialize-EasitManagementFramework
Get-EMFConfig
Stop-Transcript
```

### Example 3

```powershell
Start-Transcript -Path "$Home\EasitAB_20210412_get-emfconfig.log"
Get-EMFConfig -ConfigurationName Test
An error occurred
Get-EMFConfig -ConfigurationName Test -Verbose
Stop-Transcript
```

## Tests

### Test 1

Install Easit Management Framework module.

```powershell
Install-Module EasitManagementFramework -Scope CurrentUser
```

### Test 2

Initialize Easit Management Framework.

```powershell
Initialize-EasitManagementFramework
```

### Test 3

Look at the configuration for Easit Management Framework.

```powershell
Get-EMFConfig -ConfigurationName Prod
Get-EMFConfig -ConfigurationName Test
Get-EMFConfig -ConfigurationName Dev
```

### Test 4

Update the configuration for Easit Management Framework by specifying a parameter.

```powershell
Set-EMFConfig -ConfigurationName Test -EasitRoot 'D:\Easit'
```

### Test 5

Update the configuration for Easit Management Framework by providing an array.

```powershell
Set-EMFConfig -ConfigurationName Test -PropertySetting "EasitRoot,D:\Easit","SystemRoot,D:\Easit\Systems\Test"
```

### Test 6

Validate Easit Management Framework configuration file.

```powershell
Test-EMFXMLData
```

### Test 7

Create a new Easit Management Framework configuration file. The expected result is to get a warning telling us to use Set-EMFConfig to update configuration!

```powershell
$configSettings = @{WarName='ROOT';SystemRoot='D:\Easit\Systems\Test'}
New-EMFConfig -ConfigurationName 'Test' -ConfigurationSettings $configSettings
```

### Test 8

Rename current configuration file and then create a new configuration file.

```powershell
Rename-Item -Path "$Home\EMF\emfConfig.xml" -NewName 'emfConfig_bak.xml'
$configSettings = @{WarName='ROOT';SystemRoot='D:\Easit\Systems\Test'}
New-EMFXMLData -ConfigurationName 'Test' -ConfigurationSettings $configSettings
```

When you have completed this test, please remove emfConfig.xml and rename emfConfig_bak.xml to emfConfig.xml.

### Test 9

Get all scheduled Easit tasks.

```powershell
Get-EasitScheduledTask
```

### Test 10

Disable and enable a scheduled Easit task.
Pick one of the tasks returned in test 9 use its name in this test.

```powershell
Disable-EasitScheduledTask -TaskName 'TaskNameFromTest9'
Enable-EasitScheduledTask -TaskName 'TaskNameFromTest9'
```

### Test 11

Please feel free to explore all functions in this module and report back any issue that you might find by opening an issue in this repository.
