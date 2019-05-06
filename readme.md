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

The resource for downloading, possible values are [Dynamics365Server90RTM\<Language\>,VisualCPlusPlusRuntime,VisualCPlusPlus2010Runtime,SQLNCli2012SP4,SQLSysClrTypes2016,SharedManagementObjects2016,MSODBCSQL,Dynamics365Server90LanguagePack\<Language\>,CRM2016RTM\<Language\>,SQLNCli2018R2,SQLSysClrTypes2012,SharedManagementObjects2012,ReportViewer2012,CRM2016LanguagePack\<Language\>,CRM2016Update01\<Language\>,CRM2016ServicePack1\<Language\>,CRM2016ServicePack1Update01\<Language\>,CRM2016ServicePack2\<Language\>,CRM2016ServicePack2Update01\<Language\>,CRM2016ServicePack2Update02\<Language\>,CRM2016ServicePack2Update03\<Language\>,CRM2016ServicePack2Update04\<Language\>,CRM2016ServicePack2Update05\<Language\>,CRM2016ReportingExtensionsUpdate01\<Language\>,CRM2016ReportingExtensionsServicePack1\<Language\>,CRM2016ReportingExtensionsServicePack1Update01\<Language\>,CRM2016ReportingExtensionsServicePack2\<Language\>,CRM2016ReportingExtensionsServicePack2Update01\<Language\>,CRM2016ReportingExtensionsServicePack2Update02\<Language\>,CRM2016ReportingExtensionsServicePack2Update03\<Language\>,CRM2016ReportingExtensionsServicePack2Update04\<Language\>,CRM2016ReportingExtensionsServicePack2Update05\<Language\>,CRM2016LanguagePackUpdate01\<Language\>,CRM2016LanguagePackServicePack1\<Language\>,CRM2016LanguagePackServicePack1Update01\<Language\>,CRM2016LanguagePackServicePack2\<Language\>,CRM2016LanguagePackServicePack2Update01\<Language\>,CRM2016LanguagePackServicePack2Update02\<Language\>,CRM2016LanguagePackServicePack2Update03\<Language\>,CRM2016LanguagePackServicePack2Update04\<Language\>,CRM2016LanguagePackServicePack2Update05\<Language\>]

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
    [-InstallAccount <pscredential>]
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

#### InstallAccount

An account that has permissions to install the software and create a database. If not specified, the current account is used. If specified, CredSSP must be configured for invoking scripts locally on the machine with altered credential.

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
    -InstallAccount $CRMInstallAccountCredential `
    -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
    -LogFilePullIntervalInSeconds 15 `
    -LogFilePullToOutput
```

## Install-Dynamics365ReportingExtensions

Installs Dynamics 365 Reporting Extensions.

### Syntax

```PowerShell
Install-Dynamics365Server
    -MediaDir <string>
    -InstanceName <string>
    [-ConfigDBServer <string>]
    [-InstallAccount <pscredential>]
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
Install-Dynamics365ReportingExtensions `
    -MediaDir \\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector `
    -ConfigDBServer $dbHostName `
    -InstanceName SQLInstance01 `
    -InstallAccount $CRMInstallAccountCredential `
    -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
    -LogFilePullIntervalInSeconds 15 `
    -LogFilePullToOutput
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
Save-Dynamics365Resource -Resource CRM2016ServicePack2Update03Sve `
    -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack2Update03Sve
Invoke-Command "$env:COMPUTERNAME.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update03Sve `
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
Save-Dynamics365Resource -Resource CRM2016ReportingExtensionsUpdate01Nor `
    -TargetDirectory C:\Install\Dynamics\CRM2016ReportingExtensionsUpdate01Nor
Invoke-Command "DB01.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Install-Dynamics365ReportingExtensionsUpdate -MediaDir \\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016ReportingExtensionsUpdate01Nor
}
```

## Install-Dynamics365LanguageUpdate

Installs Dynamics 365 Server Language Pack update.

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
Save-Dynamics365Resource -Resource CRM2016LanguagePackServicePack2Update03Nor `
    -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update03Nor
Install-Dynamics365ReportingExtensionsUpdate -MediaDir C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update03Nor
```
