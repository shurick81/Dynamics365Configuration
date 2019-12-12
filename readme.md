# Introduction

A module to ease infrastructure as code tasks for Dynamics 365. It allows to use PowerShell commands in order to download and install Dynamics 365 on premise.

## Commands overview

* `Expand-Dynamics365Resource`, extracts the content of the Dynamics .exe-file resource into a file folder.
* `Save-Dynamics365Resource`, downloads the file resource and extracts into the folder.

* `Install-Dynamics365Prerequisite`, installs one specified or all the software prerequisites.

* `Install-Dynamics365Server`, installs Dynamics 365 Server with new or existing organization.

* `Install-Dynamics365ReportingExtensions`, installs Dynamics 365 Reporting Extensions.

* `Install-Dynamics365Language`, installs Dynamics 365 language pack.

* `Install-Dynamics365Update`, installs Dynamics 365 Server update.

* `Install-Dynamics365ReportingExtensionsUpdate`, installs Dynamics 365 Server Reporting Extensions update.

* `Install-Dynamics365LanguageUpdate`, installs Dynamics 365 Server Language Pack update.

## Compatibility and support

See [Compatibility page](./compatibility.md)

# Installation

```PowerShell
Install-Module -Name Dynamics365Configuration
```

# Usage

## Dynamics365Resources

### Syntax

```PowerShell
$Dynamics365Resources
```

## Expand-Dynamics365Resource

Extracts the content of the Dynamics .exe-file resource into a file folder.
Requires elevation.

### Syntax

```PowerShell
Expand-Dynamics365Resource
    [[-ResourcePath] <string>]
    [[-TargetDirectory] <string>]
```

### Parameters

#### -ResourcePath

A path to an exe-file.

#### -TargetDirectory

The directory path where the files or directories will be saved.

### Examples

Extracting all found exe-files to the current directory:

```PowerShell
Expand-Dynamics365Resource
```

Extracting C:\Install\Dynamics\CRM9.0-Server-ENU-amd64.exe to current directory:

```PowerShell
Expand-Dynamics365Resource -ResourcePath C:\Install\Dynamics\CRM9.0-Server-ENU-amd64.exe
```

Loading all found exe-files to the specified directory:

```PowerShell
Expand-Dynamics365Resource -TargetDirectory C:\Install\Dynamics
```

Loading C:\Install\Dynamics\CRM9.0-Server-ENU-amd64.exe to the specified directory:

```PowerShell
Expand-Dynamics365Resource -ResourcePath C:\Install\Dynamics\CRM9.0-Server-ENU-amd64.exe -TargetDirectory C:\Install\Dynamics\CRM9.0-Server-ENU-amd64
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

The resource for downloading, possible values are listed in [File Resources](#File-Resources) section.

#### -TargetDirectory

The directory path where the files or directories will be saved.

### Examples

Loading all known resources to the current directory:

```PowerShell
Save-Dynamics365Resource
```

Loading CRM2016ServicePack2Update02Enu to current directory:

```PowerShell
Save-Dynamics365Resource -Resource CRM2016ServicePack2Update02Enu
```

Loading all known resources to the specified directory:

```PowerShell
Save-Dynamics365Resource -TargetDirectory c:\DynamicsResources
```

Loading CRM2016LanguagePackRus to the specified directory:

```PowerShell
Save-Dynamics365Resource -Resource CRM2016LanguagePackRus -TargetDirectory c:\DynamicsResources\CRM2016LanguagePackRus
```

## Install-Dynamics365Prerequisite

Installs one specified or all the software prerequisites.

### Syntax

```PowerShell
Install-Dynamics365Prerequisite
    [-Prerequisite <Dymanics365PrerequisiteName>]
    [-DynamicsPrerequisiteFilePath <string>]
```

### Parameters

#### -Prerequisite

Specifies if only particular prerequisite must be installed. If $null is specified, all prerequisites are installed. For Dynamics 365 9.0 possible values are [SQLNCli2012SP4,SQLSysClrTypes2016,SharedManagementObjects2016,MSODBCSQL]. For CRM 2016 possible values are [SQLNCli2018R2,SQLSysClrTypes2012,SharedManagementObjects2012,ReportViewer2012].

#### -DynamicsPrerequisiteFilePath

Specifies where the file or files are located.

### Examples

Installing all Dynamics 365 prerequisites. If any prerequisite is not found in the current directory, installing from the Internet:

```PowerShell
Install-Dynamics365Prerequisite
```

Installing specific prerequisite. If prerequisite is not found in the current directory, installing from the Internet:

```PowerShell
Install-Dynamics365Prerequisite -Prerequisite SQLNCli2012SP4
```

Installing all prerequisites from the predownloaded files. If prerequisite is not found in the current directory, installing from the Internet:

```PowerShell
Install-Dynamics365Prerequisite -DynamicsPrerequisiteFilePath C:\Install\Dynamics
```

Installing specific prerequisite from the predownloaded file. If prerequisite is not found in the current directory, installing from the Internet:

```PowerShell
Install-Dynamics365Prerequisite -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\Dynamics
```

or

```PowerShell
Install-Dynamics365Prerequisite -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\Dynamics\SQLNCli2012SP4
```

or

```PowerShell
Install-Dynamics365Prerequisite -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\Dynamics\SQLNCli2012SP4\sqlncli.msi
```

## Install-Dynamics365Server

Installs Dynamics 365 Server with new or existing organization.

### Syntax

```PowerShell
Install-Dynamics365Server
    -MediaDir <string>
    -LicenseKey <string>
    [-CreateDatabase <switch>]
    -SqlServer <string>
    -PrivUserGroup <string>
    -SQLAccessGroup <string>
    -UserGroup <string>
    -ReportingGroup <string>
    -PrivReportingGroup <string>
    -CrmServiceAccount <pscredential>
    -DeploymentServiceAccount <pscredential>
    -SandboxServiceAccount <pscredential>
    -VSSWriterServiceAccount <pscredential>
    -AsyncServiceAccount <pscredential>
    -MonitoringServiceAccount <pscredential>
    [-CreateWebSite <switch>]
    -WebSitePort <int>
    -WebSiteUrl <string>
    [-IncomingExchangeServer <string>]
    -Organization <string>
    -OrganizationUniqueName <string>
    -ReportingUrl <string>
    [-InstallDir <string>]
    [-BaseISOCurrencyCode <string>]
    [-BaseCurrencyName <string>]
    [-BaseCurrencySymbol <string>]
    [-BaseCurrencyPrecision <int>]
    [-OrganizationCollation <string>]
    [-SQM <switch>]
    [-MUOptin <switch>]
    [-Reboot <switch>]
    [-LogFilePath <string>]
    [-LogFilePullIntervalInSeconds <int32>]
    [-LogFilePullToOutput <switch>]
```

Have a look at Microsoft Dynamics 365 Server documentation: https://technet.microsoft.com/en-us/library/hh699830.aspx.

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 RTM installation files.

#### LicenseKey

See `<LicenseKey>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### InstallDir

See `<InstallDir>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### CreateDatabase

See `<Database>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### SqlServer

See `<SqlServer>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### PrivUserGroup

See `<PrivUserGroup>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### SQLAccessGroup

See `<SQLAccessGroup>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### UserGroup

See `<UserGroup>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### ReportingGroup

See `<ReportingGroup>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### PrivReportingGroup

See `<PrivReportingGroup>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### CrmServiceAccount

See `<CrmServiceAccount>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### DeploymentServiceAccount

See `<DeploymentServiceAccount>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### SandboxServiceAccount

See `<SandboxServiceAccount>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### VSSWriterServiceAccount

See `<VSSWriterServiceAccount>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### AsyncServiceAccount

See `<VSSWriterServiceAccount>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### MonitoringServiceAccount

See `<VSSWriterServiceAccount>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### CreateWebSite

See `<WebsiteUrl>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### WebSitePort

See `<WebsiteUrl>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### WebSiteUrl

See `<WebsiteUrl>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### IncomingExchangeServer

See `<Email>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### Organization

See `<Organization>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### OrganizationUniqueName

See `<OrganizationUniqueName>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### BaseISOCurrencyCode

See `<basecurrency>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### BaseCurrencyName

See `<basecurrency>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### BaseCurrencySymbol

See `<basecurrency>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### BaseCurrencyPrecision

See `<basecurrency>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### OrganizationCollation

See `<OrganizationCollation>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### ReportingUrl

See `<Reporting>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### SQM

See `<SQM>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### MUOptin

See `<muoptin>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### Reboot

See `<Reboot>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### LogFilePath

Installation log file path. By default, installation process generates time-stamped log file path unless `LogFilePath` parameter is set.

#### LogFilePullIntervalInSeconds

Interval in seconds to be used during installation process updates. By default, installation process updates output every 30 seconds.

#### LogFilePullToOutput

Switch to pull installation logs into the output every `LogFilePullIntervalInSeconds` seconds. By default, installation process updates output without detailed installation logs. This option makes installation pull newest logs from `LogFilePath` file and push them into output every `LogFilePullIntervalInSeconds` seconds. 

Use this option to get a detailed feedback on the installation process.

### Examples

```PowerShell
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
Invoke-Command "$env:COMPUTERNAME.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
    $CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
    $DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
    $SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
    $VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
    $AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
    $MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
    Save-Dynamics365Resource -Resource Dynamics365Server90RTMEnu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90RTMEnu
    Install-Dynamics365Server `
        -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
        -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
        -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
        -CreateDatabase `
        -SqlServer $env:COMPUTERNAME\SQLInstance01 `
        -PrivUserGroup "CN=CRM01PrivUserGroup,OU=CRM groups,DC=contoso,DC=local" `
        -SQLAccessGroup "CN=CRM01SQLAccessGroup,OU=CRM groups,DC=contoso,DC=local" `
        -UserGroup "CN=CRM01UserGroup,OU=CRM groups,DC=contoso,DC=local" `
        -ReportingGroup "CN=CRM01ReportingGroup,OU=CRM groups,DC=contoso,DC=local" `
        -PrivReportingGroup "CN=CRM01PrivReportingGroup,OU=CRM groups,DC=contoso,DC=local" `
        -CrmServiceAccount $CRMServiceAccountCredential `
        -DeploymentServiceAccount $DeploymentServiceAccountCredential `
        -SandboxServiceAccount $SandboxServiceAccountCredential `
        -VSSWriterServiceAccount $VSSWriterServiceAccountCredential `
        -AsyncServiceAccount $AsyncServiceAccountCredential `
        -MonitoringServiceAccount $MonitoringServiceAccountCredential `
        -CreateWebSite `
        -WebSitePort 5555 `
        -WebSiteUrl https://$env:COMPUTERNAME.contoso.local `
        -Organization "Contoso Ltd." `
        -OrganizationUniqueName Contoso `
        -BaseISOCurrencyCode USD `
        -BaseCurrencyName "US Dollar" `
        -BaseCurrencySymbol `$ `
        -BaseCurrencyPrecision 2 `
        -OrganizationCollation Latin1_General_CI_AI `
        -ReportingUrl http://$env:COMPUTERNAME/ReportServer_RSInstance01 `
        -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
        -LogFilePullIntervalInSeconds 15 `
        -LogFilePullToOutput
}
```

## Install-Dynamics365ReportingExtensions

Installs Dynamics 365 Reporting Extensions.

### Syntax

```PowerShell
Install-Dynamics365ReportingExtensions
    -MediaDir <string>
    -InstanceName <string>
    [-ConfigDBServer <string>]
    [-MUOptin <switch>]
    [-LogFilePath <string>]
    [-LogFilePullIntervalInSeconds <int32>]
    [-LogFilePullToOutput <switch>]
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 RTM installation files. Remote installation requires "WMI-WINMGMT-In-TCP" and "WMI-RPCSS-In-TCP" firewall rules enabled on the target machine to be able to control software installed.

#### InstanceName

See `<instancename>` XML node description in http://157.56.148.23/en-us/library/hh699826.aspx and http://157.56.148.23/en-us/library/hh699684.aspx.

#### ConfigDBServer

See `<configdbserver>` XML node description in http://157.56.148.23/en-us/library/hh699826.aspx and http://157.56.148.23/en-us/library/hh699684.aspx.

#### InstallAccount

An account that has permissions to install the software and create a database. If not specified, the current account is used. If specified, CredSSP must be configured for invoking scripts locally on the machine with altered credential.

#### MUOptin

See `<muoptin>` XML node description in http://157.56.148.23/en-us/library/hh699826.aspx and http://157.56.148.23/en-us/library/hh699684.aspx.

#### LogFilePath

Installation log file path. By default, installation process generates time-stamped log file path unless `LogFilePath` parameter is set.

#### LogFilePullIntervalInSeconds

Interval in seconds to be used during installation process updates. By default, installation process updates output every 30 seconds.

#### LogFilePullToOutput

Switch to pull installation logs into the output every `LogFilePullIntervalInSeconds` seconds. By default, installation process updates output without detailed installation logs. This option makes installation pull newest logs from `LogFilePath` file and push them into output every `LogFilePullIntervalInSeconds` seconds. 

Use this option to get a detailed feedback on the installation process.

### Examples

```PowerShell
Install-Dynamics365ReportingExtensions `
    -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector `
    -InstanceName SQLInstance01
```

Installs the software locally.

```PowerShell
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
Invoke-Command "DB01.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Install-Dynamics365ReportingExtensions `
        -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector `
        -InstanceName SQLInstance01 `
        -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
        -LogFilePullIntervalInSeconds 15 `
        -LogFilePullToOutput
}
```

Installs Reporting Extensions on the remote SQL machine, with detailed output.

## Install-Dynamics365Language

Installs Dynamics 365 language pack. This command does not activate language pack in CRM organization, only installs it.

### Syntax

```PowerShell
Install-Dynamics365Language
    [-MediaDir] <string>
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 language pack installation files.

### Examples

```PowerShell
Save-Dynamics365Resource -Resource Dynamics365Server90LanguagePackSve `
    -TargetDirectory C:\Install\Dynamics\Dynamics365Server90LanguagePackSve
Install-Dynamics365Language -MediaDir C:\Install\Dynamics\Dynamics365Server90LanguagePackSve
```

## Install-Dynamics365Update

Installs Dynamics 365 Server update.

### Syntax

```PowerShell
Install-Dynamics365Update
    [-MediaDir] <string>
    [-LogFilePath <string>]
    [-LogFilePullIntervalInSeconds <int32>]
    [-LogFilePullToOutput <switch>]
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 Server update installation files.

#### LogFilePath

Installation log file path. By default, installation process generates time-stamped log file path unless `LogFilePath` parameter is set.

#### LogFilePullIntervalInSeconds

Interval in seconds to be used during installation process updates. By default, installation process updates output every 30 seconds.

#### LogFilePullToOutput

Switch to pull installation logs into the output every `LogFilePullIntervalInSeconds` seconds. By default, installation process updates output without detailed installation logs. This option makes installation pull newest logs from `LogFilePath` file and push them into output every `LogFilePullIntervalInSeconds` seconds. 

Use this option to get a detailed feedback on the installation process.

### Examples

```PowerShell
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
Save-Dynamics365Resource -Resource Dynamics365Server90Update09Sve `
    -TargetDirectory C:\Install\Dynamics\Dynamics365Server90Update09Sve
Invoke-Command "$env:COMPUTERNAME.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update09Sve `
        -LogFilePath c:\tmp\Dynamics365ServerUpdate823InstallLog.txt `
        -LogFilePullIntervalInSeconds 15 `
        -LogFilePullToOutput
}
```

## Install-Dynamics365ReportingExtensionsUpdate

Installs Dynamics 365 Server Reporting Extensions update.

### Syntax

```PowerShell
Install-Dynamics365ReportingExtensionsUpdate
    [-MediaDir] <string>
    [-LogFilePath <string>]
    [-LogFilePullIntervalInSeconds <int32>]
    [-LogFilePullToOutput <switch>]
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 Server update installation files.

#### LogFilePath

Installation log file path. By default, installation process generates time-stamped log file path unless `LogFilePath` parameter is set.

#### LogFilePullIntervalInSeconds

Interval in seconds to be used during installation process updates. By default, installation process updates output every 30 seconds.

#### LogFilePullToOutput

Switch to pull installation logs into the output every `LogFilePullIntervalInSeconds` seconds. By default, installation process updates output without detailed installation logs. This option makes installation pull newest logs from `LogFilePath` file and push them into output every `LogFilePullIntervalInSeconds` seconds. 

Use this option to get a detailed feedback on the installation process.

### Examples

```PowerShell
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
Save-Dynamics365Resource -Resource Dynamics365Server90ReportingExtensionsUpdate09Nor `
    -TargetDirectory C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate09Nor
Invoke-Command "DB01.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Install-Dynamics365ReportingExtensionsUpdate -MediaDir \\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate09Nor
}
```

## Install-Dynamics365LanguageUpdate

Installs Dynamics 365 Server Language Pack update.

### Syntax

```PowerShell
Install-Dynamics365LanguageUpdate
    [-MediaDir] <string>
    [-LogFilePath <string>]
    [-LogFilePullIntervalInSeconds <int32>]
    [-LogFilePullToOutput <switch>]
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 Server update installation files.

#### LogFilePath

Installation log file path. By default, installation process generates time-stamped log file path unless `LogFilePath` parameter is set.

#### LogFilePullIntervalInSeconds

Interval in seconds to be used during installation process updates. By default, installation process updates output every 30 seconds.

#### LogFilePullToOutput

Switch to pull installation logs into the output every `LogFilePullIntervalInSeconds` seconds. By default, installation process updates output without detailed installation logs. This option makes installation pull newest logs from `LogFilePath` file and push them into output every `LogFilePullIntervalInSeconds` seconds. 

Use this option to get a detailed feedback on the installation process.

### Examples

```PowerShell
Save-Dynamics365Resource -Resource CRM2016LanguagePackServicePack2Update09Nor `
    -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update09Nor
Install-Dynamics365LanguageUpdate -MediaDir C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update09Nor
```

# File Resources

The following file resources can be referenced in the module:

| Resource group | Code Name | Number of files | Comments |
| -- | -- | -: | -- |
| **Dynamics 9** |  |  |  |
| RTM | Dynamics365Server90RTM\<Language\> | 25 |  |
| Language pack | Dynamics365Server90LanguagePack<Language> | 45 |  |
| Server Update 0.3 | Dynamics365Server90Update03\<Language\> | 25 |  |
| RS Extensions Update 0.3 | Dynamics365Server90ReportingExtensionsUpdate03\<Language\> | 24 | Chk language is missing |
| Server Update 0.4 | Dynamics365Server90Update04\<Language\> | 25 |  |
| RS Extensions Update 0.4 | Dynamics365Server90ReportingExtensionsUpdate04\<Language\> | 25 |  |
| Server Update 0.5 | Dynamics365Server90Update05\<Language\> | 25 |  |
| RS Extensions Update 0.5 | Dynamics365Server90ReportingExtensionsUpdate05\<Language\> | 25 |  |
| Server Update 0.6 | Dynamics365Server90Update06\<Language\> | 25 |  |
| RS Extensions Update 0.6 | Dynamics365Server90ReportingExtensionsUpdate06\<Language\> | 25 |  |
| Server Update 0.7 | Dynamics365Server90Update07\<Language\> | 25 |  |
| RS Extensions Update 0.7 | Dynamics365Server90ReportingExtensionsUpdate07\<Language\> | 25 |  |
| Server Update 0.8 | Dynamics365Server90Update08\<Language\> | 25 |  |
| RS Extensions Update 0.8 | Dynamics365Server90ReportingExtensionsUpdate08\<Language\> | 25 |  |
| Server Update 0.9 | Dynamics365Server90Update09\<Language\> | 25 |  |
| RS Extensions Update 0.9 | Dynamics365Server90ReportingExtensionsUpdate09\<Language\> | 25 |  |
| Server Update 0.10 | Dynamics365Server90Update10\<Language\> | 25 |  |
| RS Extensions Update 0.10 | Dynamics365Server90ReportingExtensionsUpdate10\<Language\> | 25 |  |
| **Dynamics 8** |  |  |  |
| RTM | CRM2016RTM\<Language\> | 25 |  |
| Language pack | CRM2016LanguagePack<Language> | 45 |  |
| Server Update 0.1 | CRM2016Update01\<Language\> | 25 |  |
| RS Extensions Update 0.1 | CRM2016ReportingExtensionsUpdate01\<Language\> | 25 |  |
| MUI Update 0.1 | CRM2016LanguagePackUpdate01\<Language\> | 45 |  |
| Server Update 1.0 | CRM2016ServicePack1\<Language\> | 25 |  |
| RS Extensions Update 1.0 | CRM2016ReportingExtensionsServicePack1\<Language\> | 25 |  |
| MUI Update 1.0 | CRM2016LanguagePackServicePack1\<Language\> | 45 |  |
| Server Update 1.1 | CRM2016ServicePack1Update01\<Language\> | 25 |  |
| RS Extensions Update 1.1 | CRM2016ReportingExtensionsServicePack1Update01\<Language\> | 25 |  |
| MUI Update 1.1 | CRM2016LanguagePackServicePack1Update01\<Language\> | 45 |  |
| Server Update 2.0 | CRM2016ServicePack2\<Language\> | 25 |  |
| RS Extensions Update 2.0 | CRM2016ReportingExtensionsServicePack2\<Language\> | 25 |  |
| MUI Update 2.0 | CRM2016LanguagePackServicePack2\<Language\> | 45 |  |
| Server Update 2.1 | CRM2016ServicePack2Update01\<Language\> | 25 |  |
| RS Extensions Update 2.1 | CRM2016ReportingExtensionsServicePack2Update01\<Language\> | 25 |  |
| MUI Update 2.1 | CRM2016LanguagePackServicePack2Update01\<Language\> | 45 |  |
| Server Update 2.2 | CRM2016ServicePack2Update02\<Language\> | 25 |  |
| RS Extensions Update 2.2 | CRM2016ReportingExtensionsServicePack2Update02\<Language\> | 25 |  |
| MUI Update 2.2 | CRM2016LanguagePackServicePack2Update02\<Language\> | 45 |  |
| Server Update 2.2 | CRM2016ServicePack2Update02\<Language\> | 25 |  |
| RS Extensions Update 2.2 | CRM2016ReportingExtensionsServicePack2Update02\<Language\> | 25 |  |
| MUI Update 2.2 | CRM2016LanguagePackServicePack2Update02\<Language\> | 45 |  |
| Server Update 2.3 | CRM2016ServicePack2Update03\<Language\> | 25 |  |
| RS Extensions Update 2.3 | CRM2016ReportingExtensionsServicePack2Update03\<Language\> | 25 |  |
| MUI Update 2.3 | CRM2016LanguagePackServicePack2Update03\<Language\> | 45 |  |
| Server Update 2.4 | CRM2016ServicePack2Update04\<Language\> | 25 |  |
| RS Extensions Update 2.4 | CRM2016ReportingExtensionsServicePack2Update04\<Language\> | 25 |  |
| MUI Update 2.4 | CRM2016LanguagePackServicePack2Update04\<Language\> | 45 |  |
| Server Update 2.5 | CRM2016ServicePack2Update05\<Language\> | 25 |  |
| RS Extensions Update 2.5 | CRM2016ReportingExtensionsServicePack2Update05\<Language\> | 25 |  |
| MUI Update 2.5 | CRM2016LanguagePackServicePack2Update05\<Language\> | 45 |  |
| Server Update 2.6 | CRM2016ServicePack2Update06\<Language\> | 25 |  |
| RS Extensions Update 2.6 | CRM2016ReportingExtensionsServicePack2Update06\<Language\> | 25 |  |
| MUI Update 2.6 | CRM2016LanguagePackServicePack2Update06\<Language\> | 45 |  |
| Server Update 2.7 | CRM2016ServicePack2Update07\<Language\> | 25 |  |
| RS Extensions Update 2.7 | CRM2016ReportingExtensionsServicePack2Update07\<Language\> | 25 |  |
| MUI Update 2.7 | CRM2016LanguagePackServicePack2Update07\<Language\> | 45 |  |
| Server Update 2.8 | CRM2016ServicePack2Update08\<Language\> | 24 | Sve language is missing |
| RS Extensions Update 2.8 | CRM2016ReportingExtensionsServicePack2Update08\<Language\> | 24 | Sve language is missing |
| MUI Update 2.8 | CRM2016LanguagePackServicePack2Update08\<Language\> | 44 | Sve language is missing |
| Server Update 2.9 | CRM2016ServicePack2Update09\<Language\> | 25 |  |
| RS Extensions Update 2.9 | CRM2016ReportingExtensionsServicePack2Update09\<Language\> | 25 |  |
| MUI Update 2.9 | CRM2016LanguagePackServicePack2Update09\<Language\> | 45 |  |
| Server Update 2.10 | CRM2016ServicePack2Update10\<Language\> | 25 |  |
| RS Extensions Update 2.10 | CRM2016ReportingExtensionsServicePack2Update10\<Language\> | 25 |  |
| MUI Update 2.10 | CRM2016LanguagePackServicePack2Update10\<Language\> | 45 |  |
| Server Update 2.11 | CRM2016ServicePack2Update11\<Language\> | 25 |  |
| RS Extensions Update 2.11 | CRM2016ReportingExtensionsServicePack2Update11\<Language\> | 25 |  |
| MUI Update 2.11 | CRM2016LanguagePackServicePack2Update11\<Language\> | 45 |  |
| Server Update 2.12 | CRM2016ServicePack2Update12\<Language\> | 25 |  |
| RS Extensions Update 2.12 | CRM2016ReportingExtensionsServicePack2Update12\<Language\> | 25 |  |
| MUI Update 2.12 | CRM2016LanguagePackServicePack2Update12\<Language\> | 45 |  |
| Prerequisites |  | 10 |  |
| **Total** |  | 2066 |  |

## Languages of RTM versions, for both v8 and v9

* ENU (en-US)
* SAU (ar-SA)
* CHK (zh-HK)
* CHS (zh-CN)
* CHT (zh-TW)
* CSY (cs-CZ)
* DAN (da-DK)
* NLD (nl-NL)
* FIN (fi-FI)
* FRA (fr-FR)
* DEU (de-DE)
* ELL (el-GR)
* HEB (he-IL)
* HUN (hu-HU)
* ITA (it-IT)
* JPN (ja-JP)
* KOR (ko-KR)
* NOR (nb-NO)
* PLK (pl-PL)
* PTB (pt-BR)
* PTG (pt-PT)
* RUS (ru-RU)
* ESN (es-ES)
* SVE (sv-SE)
* TRK (tr-TR)

## Dynamics 365 Server Language packs, for both v8 and v9

* SAU (ar-SA)
* EUS (eu-ES)
* BGR (bg-BG)
* CAT (ca-ES)
* CHK (zh-HK)
* CHS (zh-CN)
* CHT (zh-TW)
* HRV (hr-HR)
* CSY (cs-CZ)
* DAN (da-DK)
* NLD (nl-NL)
* ENU (en-US)
* ETI (et-EE)
* FIN (fi-FI)
* FRA (fr-FR)
* GLC (gl-ES)
* DEU (de-DE)
* ELL (el-GR)
* HEB (he-IL)
* HIN (hi-IN)
* HUN (hu-HU)
* IND (id-ID)
* ITA (it-IT)
* JPN (ja-JP)
* KKZ (kk-KZ)
* KOR (ko-KR)
* LVI (lv-LV)
* LTH (lt-LT)
* MSL (ms-MY)
* NOR (nb-NO)
* PLK (pl-PL)
* PTB (pt-BR)
* PTG (pt-PT)
* ROM (ro-RO)
* RUS (ru-RU)
* SRB (sr-Cyrl-RS)
* SRL (sr-Latn-RS)
* SKY (sk-SK)
* SLV (sl-SI)
* ESN (es-ES)
* SVE (sv-SE)
* THA (th-TH)
* TRK (tr-TR)
* UKR (uk-UA)
* VIT (vi-VN)
