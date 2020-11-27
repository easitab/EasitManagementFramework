# Framework structure and anatomy

## Table of Contents
1. [Anatomy](#anatomy)
2. [Configuration file](#Configuration-file)
3. [Schemas](#schemas)
4. [Cmdlets](#cmdlets)
5. [Private cmdlets](#private-cmdlets)
6. [Public cmdlets](#public-cmdlets)

## Anatomy

### Configuration file

All settings for the framework lives in a configuration file located in EMFHome. This is where the framework first look for settings used in all the cmdlets.<br>

Default values and paths:

* EMFHome = C:\Users\yourusername\EMF
* Configuration filename = emfConfig.xml

The configuration file contains values for one or more systems. Each system has one or more properties with a value, see example below:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<systems>
  <Prod> <!-- Configuration name -->
    <SystemRoot>D:\Easit\Systems\Prod</SystemRoot> <!-- SystemRoot = Configuration property -->
    <ServiceName>EasitProd</ServiceName> <!-- EasitProd = Configuration property value -->
    <EasitRoot>D:\Easit</EasitRoot>
    <BackupRoot>D:\Easit\_Backup\Prod</BackupRoot>
    <TomcatRoot>D:\Easit\Tomcat\Prod</TomcatRoot>
    <EmailRequestRoot>D:\Easit\EmailRequest</EmailRequestRoot>
    <ImportClientRoot>D:\Easit\ImportClient</ImportClientRoot>
  </Prod>
</systems>
```

Example of a configuration file with multiple systems:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<systems>
  <Test>
    <SystemRoot>D:\Easit\Systems2\Test</SystemRoot>
    <ServiceName>EasitTest</ServiceName>
    <EasitRoot>D:\Easit</EasitRoot>
    <BackupRoot>C:\Easit\_Backup2\Test</BackupRoot>
    <TomcatRoot>D:\Easit\Tomcat\Test</TomcatRoot>
    <EmailRequestRoot>D:\Easit\Tomcat\Test</EmailRequestRoot>
    <ImportClientRoot>D:\Easit\Tomcat\Test</ImportClientRoot>
  </Test>
  <Dev>
    <SystemRoot>D:\Easit\Systems\Dev</SystemRoot>
    <ServiceName>EasitDev</ServiceName>
    <EasitRoot>D:\Easit</EasitRoot>
    <BackupRoot>C:\Easit\_Backup2\Dev</BackupRoot>
    <TomcatRoot>D:\Easit\Tomcat\Dev</TomcatRoot>
    <EmailRequestRoot>D:\Easit\Tomcat\Dev</EmailRequestRoot>
    <ImportClientRoot>D:\Easit\Tomcat\Dev</ImportClientRoot>
  </Dev>
</systems>
```

These properties and its values can be changed manually or by using *Set-EMFConfig*, [more information here](https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Set-EMFConfig.md).

We provide an example file that you can download either from [here](https://raw.githubusercontent.com/easitab/EasitManagementFramework/development/configurations/emfConfig.xml) or by using the cmdlet *Initialize-EasitManagementFramework*, [more information about the cmdlet here](https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/Initialize-EasitManagementFramework.md). You can also create the file manually or by running *New-EMFConfig*, [more information about the cmdlet here](https://github.com/easitab/EasitManagementFramework/blob/development/docs/v1/New-EMFConfig.md).

### Schemas

In order to validate that the configuration file is correct we provide a schema, emfSchema.xsd, tha you can find [here](https://github.com/easitab/EasitManagementFramework/tree/development/schemas). If you used *Initialize-EasitManagementFramework* the schema have been downloaded for you.

### Cmdlets

All cmdlets that needs a value from the configuration file, for example *Get-EasitEmailRequestMailbox*, *Set-EasitEmailRequestMailbox* and *Start-EasitGOApplication*, starts by running *Get-EMFConfig* and uses the returned values to execute its job or task.

If the configuration file or configuration name is not found you will get an error like *No configuration found named XXXX* or *Path to configuration file does not exist*.

### Private cmdlets

There is some cmdlets that is not available from the consol or commandline, these are called private cmdlets and is used by the framework "under the hood" and not aimed for use by any user. One example of this is *Import-EMFXMLData* that is used by *Get-EMFConfig*. Private cmdlets are located in projectroot/source/private/ and cmdlets in this folder is not be available for the user when the module is built.

### Public cmdlets

All cmdlets are located in projectroot/source/public and this is the cmdlets that will be available to the user when the module is built.