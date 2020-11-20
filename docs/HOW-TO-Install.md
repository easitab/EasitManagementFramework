# How to install Easit Management Framework

## Prerequisites

- Windows Powershell 5.1
- A server with Easit GO / BPS installed.
- An account with admin rights on the server where Easit GO / BPS is installed.

## Install

The EasitManagementFramework module is not signed so you need to set execution policy to either Bypass or Unrestricted.<br>
Set to either Process (Affects only the current PowerShell session) or CurrentUser (Affects only the current user).<br>
[More information: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy)

### Step 1

Connect to the server where Easit GO / BPS is installed. How you connect to the server is up to you, WinRM, RDP, SSH, as long as you can run PowerShell as an Administrator you are good to go!

#### Example 1
```powershell
PS C:\> $Server01 = New-PSSession -ComputerName Server01
PS C:\> Enter-PSSession -Session $Server01
```

#### Example 2
```powershell
PS C:\> Enter-PSSession -ComputerName Server01
```

### Step 2

```powershell
PS C:\> Install-Module -Name EasitManagementFramework
PS C:\> Import-Module -Name EasitManagementFramework
```
*OR*
```powershell
PS C:\> Set-ExecutionPolicy -ExecutionPolicy ByPass -Scope CurrentUser
PS C:\> Install-Module -Name EasitManagementFramework -Scope CurrentUser
PS C:\> Import-Module -Name EasitManagementFramework
```

### Step 3
```powershell
PS C:\> Initialize-EasitManagementFramework
```

This will create a folder called EMF in your user profile on the server and download some assets (emfConfig.xml and emfSchema.xsd) to that folder.
These files is needed in order to use the framework. [More information here](https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Initialize-EasitManagementFramework.md)
