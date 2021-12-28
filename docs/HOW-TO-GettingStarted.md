# Getting started with Easit Management Framework

## Prerequisites

- Easit Management Framework installed on the server where Easit GO / BPS installed.

Instructions on how to install can be found [here](https://github.com/easitab/EasitManagementFramework/blob/development/docs/HOW-TO-Install.md).

## Setting up the framework

So, you have just installed the framework and are eager to get started? Good!

### Step 1

Locate where Easit GO / BPS is installed. Usually Easit GO / BPS is installed under D:\Easit but please look this up before continuing to the next step.

### Step 2

Find out what name the Windows Service for Easit GO / BPS is. The easiest way to do this is by running the following command in an elevated session of Windows PowerShell.

```powershell
PS C:\> Get-Service -Name '*easit*'
```

Now you have everything you need to configure the framework for the systems installed on the server that you would like to manage.

### Step 3

Download configuration templates.

```powershell
PS C:\> Initialize-EasitManagementFramework
```

This will create a folder called EMF in the environmental variable ALLUSERSPROFILE (most often C:\ProgramData) on the server and download some assets (emfConfig.xml and emfSchema.xsd) to that folder.

### Step 4

Locate where the configuration files have been save by running the following command.

```powershell
PS C:\> $env:ALLUSERSPROFILE

C:\ProgramData

PS C:\>
```

### Step 5

Open the path, in out example *C:\ProgramData*, find a directory called *EMF* and open it. In this directory you should have a file called *emfConfig.xml*.
Right click on it and choose *Edit*. It should look something like [this](https://github.com/easitab/EasitManagementFramework/blob/development/configurations/emfConfig.xml).

The file contains an element for each system that could be installed on the server. Begin by removing elements for the systems that is not installed on the server.
If you are running test and production on separate servers and currently are working on the test server you can remove the prod element.

#### Before

```xml
<?xml version="1.0" encoding="UTF-8"?>
<systems>
  <Test>
    #Properties
  </Test>
  <Prod>
    #Properties
  </Prod>
</systems>
```

#### After

```xml
<?xml version="1.0" encoding="UTF-8"?>
<systems>
  <Test>
    #Properties
  </Test>
</systems>
```

When all elements that should not be used have been remove proceed with updating the values for each property to match your installation of Easit GO / BPS.
When the values for all properties match your installation you can save and close *emfConfig.xml* and you are ready to explore all functions within the framework.

#### List available functions

```powershell
PS C:\> Get-Command -Module EasitManagementFramework
```

#### Documentation for each function

[Docs](https://github.com/easitab/EasitManagementFramework/tree/development/docs/v1)
