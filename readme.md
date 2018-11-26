# Introduction

A module to ease infrastructure as code and configuration as code tasks for Dynamics 365.

# Installation

# Usage

## Dynamics365Resources

### Syntax

```PowerShell
$Dynamics365Resources
```

## Save-Dynamics365Resource

Downloads the file resource and extracts into the folder.
Requires elevation.

### Syntax

```PowerShell
Save-Dynamics365Resource
    [[-Resource] <Dynamics365ResoucreName>]
    [[-TargetDirectory] <string>]
```

### Parameters

#### -Resource

The resource for downloading, possible values are [CRM2016, CRM2016LanguagePackXxx, CRM2016Update01, CRM2016ServicePack1, CRM2016ServicePack1Update01, CRM2016ServicePack2, CRM2016ServicePack2Update01, CRM2016ServicePack2Update02]

#### -TargetDirectory

The directory path where the files or directories will be saved.

### Examples

Loading all known resources to the current directory:

```PowerShell
Save-Dynamics365ResouceUrl
```

Loading CRM2016ServicePack2Update02 to current directory:

```PowerShell
Save-Dynamics365ResouceUrl -Resource CRM2016ServicePack2Update02
```

Loading all known resources to the specified directory:

```PowerShell
Save-Dynamics365ResouceUrl -TargetDirectory c:\CRMResources
```

Loading CRM2016LanguagePackRus to the specified directory:

```PowerShell
Save-Dynamics365ResouceUrl -Resource CRM2016LanguagePackRus c:\CRMResources\CRM2016ServicePack2Update02
```

## Install-Dynamics365Prerequisites

Installs one specified or all the software prerequisites.

### Syntax

```PowerShell
Install-Dynamics365Prerequisites
    [-DynamicsInstallationMediaDirectoryPath <string>]
    [-Prerequisite <Dymanics365PrerequisiteName>]
    [-DynamicsPrerequisiteFilePath <string>]
```

### Parameters

#### -DynamicsInstallationMediaDirectoryPath

Specifies, where the Dynamics 365 RTM installation files are located.

#### -Prerequisite

Specifies if only particular prerequisite must be installed. If $null is specified, all prerequisites are installed. For Dynamics 365 9.0 possible values are [SQLNCli2012SP4,SQLSysClrTypes2016,SharedManagementObjects2016,MSODBCSQL]. For CRM 2016 possible values are [SQLNCli2018R2,SQLSysClrTypes2012,SharedManagementObjects2012,ReportViewer2012].

#### -DynamicsPrerequisiteFilePath

Specifies where the file or files are located.

### Examples

Installing all Dynamics 365 9.0 prerequisites from the Internet:

```PowerShell
Install-Dynamics365Prerequisites -DynamicsInstallationMediaDirectoryPath C:\Install\CRM\CRM9.0-Server-ENU-amd64
```

Installing specific prerequisite from the Internet:

```PowerShell
Install-Dynamics365Prerequisites -Prerequisite SQLNCli2012SP4
```

Installing all prerequisites from the predownloaded files:

```PowerShell
Install-Dynamics365Prerequisites -DynamicsInstallationMediaDirectoryPath C:\Install\CRM\CRM9.0-Server-ENU-amd64 -DynamicsPrerequisiteFilePath C:\Install\CRM
```

Installing specific prerequisite from the predownloaded file:

```PowerShell
Install-Dynamics365Prerequisites -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\CRM\Prerequisites
```
