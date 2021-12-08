# How to install Easit Management Framework

## Prerequisites

- Windows Powershell 5.1
- A server with Easit GO / BPS installed.
- An account with admin rights on the server where Easit GO / BPS is installed.

## Install

This module is not digitaly signed wich can affect some users experiences. [For more information about execution policys in Windows PowerShell can be found here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-5.1)

### Step 1

Connect to the server where Easit GO / BPS is installed. How you connect to the server is up to you, WinRM, RDP, SSH, as long as you can run Windows PowerShell as an administrator you are good to go!

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

If you would like to install the module for the current user and change its execution policy.

```powershell
PS C:\> Set-ExecutionPolicy -ExecutionPolicy ByPass -Scope CurrentUser
PS C:\> Install-Module -Name EasitManagementFramework -Scope CurrentUser
PS C:\> Import-Module -Name EasitManagementFramework
```

### Step 3

```powershell
PS C:\> Initialize-EasitManagementFramework
```

This will create a folder called EMF in the environmental variable ALLUSERSPROFILE (most often C:\ProgramData) on the server and download some assets (emfConfig.xml and emfSchema.xsd) to that folder.
These files is needed in order to use the framework. [More information here](https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Initialize-EasitManagementFramework.md)
