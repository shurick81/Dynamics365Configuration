# Introduction

A module to ease infrastructure as code tasks for Dynamics 365 Customer Engagement (on-premises). It allows to use PowerShell commands in order to download and install Dynamics 365 on premise.

![Dynamics365Configuration Concept](/doc/Concept.png)

## Commands overview

* `Get-Dynamics365ServerLanguage`, returns primary Dynamics 365 Customer Engagement language installed on the machine.

* `Get-Dynamics365ServerRole`, returns lists of installed server roles.

* `Get-Dynamics365ServerVersion`, returns installed server version.

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

## Get-Dynamics365ServerLanguage

Returns primary Dynamics 365 Customer Engagement language installed on the machine.

### Syntax

```PowerShell
Get-Dynamics365ServerLanguage
```

## Get-Dynamics365ServerRole

Returns primary Dynamics 365 Customer Engagement language installed on the machine.

### Syntax

```PowerShell
Get-Dynamics365ServerRole
```

## Get-Dynamics365ServerVersion

Returns primary Dynamics 365 Customer Engagement language installed on the machine.

### Syntax

```PowerShell
Get-Dynamics365ServerVersion
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

Specifies if only particular prerequisite must be installed. If $null is specified, all prerequisites are installed. For Dynamics 365 Server 9.0 required prerequisites are [SQLNCli2012SP4,SQLSysClrTypes2016,SharedManagementObjects2016,VisualCPlusPlusRuntime,VisualCPlusPlus2010Runtime,MSODBCSQL]. For CRM 2016 required prerequisites are [SQLNCli2008R2,SQLSysClrTypes2012,SharedManagementObjects2012,ReportViewer2012,VisualCPlusPlusRuntime,VisualCPlusPlus2010Runtime]. For reporting extensions, the only prerequisite is `VisualCPlusPlusRuntime`

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

Installs Dynamics 365 Server with new or existing configuration database.

### Syntax

```PowerShell
Install-Dynamics365Server
    -MediaDir <string>
    -SqlServer <string>
    -OU <string>
    [-Patch <string>]
    [-LicenseKey <string>]
    [-InstallDir <string>]
    [-CreateDatabase <switch>]
    [-ServerRoles <string>[]]
    [-CrmServiceAccount <pscredential>]
    [-DeploymentServiceAccount <pscredential>]
    [-SandboxServiceAccount <pscredential>]
    [-VSSWriterServiceAccount <pscredential>]
    [-AsyncServiceAccount <pscredential>]
    [-MonitoringServiceAccount <pscredential>]
    [-CreateWebSite <switch>]
    [-WebSitePort <int>]
    [-WebSiteUrl <string>]
    [-IncomingExchangeServer <string>]
    [-Organization <string>]
    [-OrganizationUniqueName <string>]
    [-ReportingUrl <string>]
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

```PowerShell
Install-Dynamics365Server
    -MediaDir <string>
    -SqlServer <string>
    [-Patch <string>]
    [-LicenseKey <string>]
    [-InstallDir <string>]
    [-CreateDatabase <switch>]
    [-ServerRoles <string>[]]
    [-PrivUserGroup <string>]
    [-SQLAccessGroup <string>]
    [-UserGroup <string>]
    [-ReportingGroup <string>]
    [-PrivReportingGroup <string>]
    [-AutoGroupManagementOff <switch>]
    [-CrmServiceAccount <pscredential>]
    [-DeploymentServiceAccount <pscredential>]
    [-SandboxServiceAccount <pscredential>]
    [-VSSWriterServiceAccount <pscredential>]
    [-AsyncServiceAccount <pscredential>]
    [-MonitoringServiceAccount <pscredential>]
    [-CreateWebSite <switch>]
    [-WebSitePort <int>]
    [-WebSiteUrl <string>]
    [-IncomingExchangeServer <string>]
    [-Organization <string>]
    [-OrganizationUniqueName <string>]
    [-ReportingUrl <string>]
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

#### Patch

Path to the msp patch file or directory.

#### LicenseKey

See `<LicenseKey>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### SqlServer

See `<SqlServer>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### InstallDir

See `<InstallDir>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### CreateDatabase

Create Dynamics 365 configuration database. See `<Database>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

#### ServerRoles

Array of strings containing server role names. Possible role names are `FrontEnd`, `BackEnd`, `DeploymentAdministration`, `WebApplicationServer`, `OrganizationWebService`, `DiscoveryWebService`, `HelpServer`, `AsynchronousProcessingService`, `EmailConnector`, `SandboxProcessingService`, `DeploymentTools`, `DeploymentWebService`, `VSSWriter`. For further information refer to https://docs.microsoft.com/en-us/dynamics365/customerengagement/on-premises/deploy/microsoft-dynamics-365-server-roles#available-group-server-roles and https://docs.microsoft.com/en-us/dynamics365/customerengagement/on-premises/deploy/install-using-command-prompt#microsoft-dynamics-365-server-role-names-used-in-the-xml-configuration-file.

#### OU

Specifies the Active Directory organizational unit (OU) where the security groups will be created. You can’t use `PrivUserGroup`, `SQLAccessGroup`, `UserGroup`, `ReportingGroup` or `PrivReportingGroup` parameters with the `OU` parameter. Setup won’t continue if you specify both elements together.

See `<OU>` XML node description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

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

#### AutoGroupManagementOff

See `autogroupmanagementoff` XML attribute description in https://technet.microsoft.com/en-us/library/hh699830.aspx.

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

Installing a single server with an organization

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
    Install-Dynamics365Server `
        -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
        -CreateDatabase `
        -SqlServer $env:COMPUTERNAME\SQLInstance01 `
        -Patch C:\Install\Dynamics\Dynamics365Server90Update28Enu `
        -OU "OU=CRM groups,DC=contoso,DC=local" `
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
        -LogFilePath "c:\tmp\Dynamics365ServerInstallLog$( ( Get-Date -Format u ).Replace(' ','-').Replace(':','-') ).txt" `
        -LogFilePullIntervalInSeconds 15 `
        -LogFilePullToOutput
}
```

Installing only back end and deployment administration server roles, without organization provisioning, specific AD groups

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
    Install-Dynamics365Server `
        -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
        -CreateDatabase `
        -ServerRoles BackEnd, DeploymentAdministration `
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
        -LogFilePath "c:\tmp\Dynamics365ServerInstallLog$( ( Get-Date -Format u ).Replace(' ','-').Replace(':','-') ).txt" `
        -LogFilePullIntervalInSeconds 15 `
        -LogFilePullToOutput
}
```

Jonining existing configuration database and Installing only front end server roles

```PowerShell
Install-Dynamics365Server `
    -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
    -ServerRoles FrontEnd `
    -SqlServer $dbHostName\SQLInstance01
```

Use the same command for adding roles on the server where Dynamics is already installed

## Install-Dynamics365ReportingExtensions

Installs Dynamics 365 Reporting Extensions.

### Syntax

```PowerShell
Install-Dynamics365ReportingExtensions
    -MediaDir <string>
    [-InstanceName <string>]
    [-Patch <string>]
    [-ConfigDBServer <string>]
    [-AutoGroupManagementOff <switch>]
    [-MUOptin <switch>]
    [-LogFilePath <string>]
    [-LogFilePullIntervalInSeconds <int32>]
    [-LogFilePullToOutput <switch>]
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 RTM installation files. Remote installation requires "WMI-WINMGMT-In-TCP" and "WMI-RPCSS-In-TCP" firewall rules enabled on the target machine to be able to control software installed.

#### InstanceName

Reporting Services instance to use. For more details, see `<instancename>` XML node description in http://157.56.148.23/en-us/library/hh699826.aspx and http://technet.microsoft.com/en-us/library/hh699826(v=crm.6).aspx.

#### Patch

Path to the msp patch file or directory.

#### ConfigDBServer

SQL instance that contains Dynamics configuration database. For more details, see `<configdbserver>` XML node description in http://157.56.148.23/en-us/library/hh699826.aspx and http://technet.microsoft.com/en-us/library/hh699826(v=crm.6).aspx.

#### AutoGroupManagementOff

See `<autogroupmanagementoff>` XML node description in http://technet.microsoft.com/en-us/library/hh699826(v=crm.6).aspx.

#### MUOptin

See `<muoptin>` XML node description in http://technet.microsoft.com/en-us/library/hh699826(v=crm.6).aspx and http://technet.microsoft.com/en-us/library/hh699826(v=crm.6).aspx.

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
    -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
    -InstanceName SQLInstance01
```

Installs the software locally.

```PowerShell
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
Invoke-Command "DB01.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Install-Dynamics365ReportingExtensions `
        -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector `
        -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
        -InstanceName SQLInstance01 `
        -Patch C:\Install\Dynamics\Dynamics365Server90Update28Enu `
        -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
        -LogFilePullIntervalInSeconds 15 `
        -LogFilePullToOutput
}
```

Installs Reporting Extensions on the remote SQL machine, with detailed output, also installing a patch.

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
| Server Update 0.11 | Dynamics365Server90Update11\<Language\> | 25 |  |
| RS Extensions Update 0.11 | Dynamics365Server90ReportingExtensionsUpdate11\<Language\> | 25 |  |
| Server Update 0.12 | Dynamics365Server90Update12\<Language\> | 25 |  |
| RS Extensions Update 0.12 | Dynamics365Server90ReportingExtensionsUpdate12\<Language\> | 25 |  |
| Server Update 0.13 | Dynamics365Server90Update13\<Language\> | 25 |  |
| RS Extensions Update 0.13 | Dynamics365Server90ReportingExtensionsUpdate13\<Language\> | 25 |  |
| Server Update 0.14 | Dynamics365Server90Update14\<Language\> | 24 | Ell language is missing |
| RS Extensions Update 0.14 | Dynamics365Server90ReportingExtensionsUpdate14\<Language\> | 24 | Ell language is missing |
| Server Update 0.15 | Dynamics365Server90Update15\<Language\> | 25 |  |
| RS Extensions Update 0.15 | Dynamics365Server90ReportingExtensionsUpdate15\<Language\> | 25 |  |
| Server Update 0.16 | Dynamics365Server90Update16\<Language\> | 25 |  |
| RS Extensions Update 0.16 | Dynamics365Server90ReportingExtensionsUpdate16\<Language\> | 25 |  |
| Server Update 0.17 | Dynamics365Server90Update17\<Language\> | 25 |  |
| RS Extensions Update 0.17 | Dynamics365Server90ReportingExtensionsUpdate17\<Language\> | 25 |  |
| Server Update 0.18 | Dynamics365Server90Update18\<Language\> | 25 |  |
| RS Extensions Update 0.18 | Dynamics365Server90ReportingExtensionsUpdate18\<Language\> | 25 |  |
| Server Update 0.19 | Dynamics365Server90Update19\<Language\> | 25 |  |
| RS Extensions Update 0.19 | Dynamics365Server90ReportingExtensionsUpdate19\<Language\> | 25 |  |
| Server Update 0.20 | Dynamics365Server90Update20\<Language\> | 25 |  |
| RS Extensions Update 0.20 | Dynamics365Server90ReportingExtensionsUpdate20\<Language\> | 25 |  |
| Server Update 0.21 | Dynamics365Server90Update21\<Language\> | 25 |  |
| RS Extensions Update 0.21 | Dynamics365Server90ReportingExtensionsUpdate21\<Language\> | 25 |  |
| Server Update 0.22 | Dynamics365Server90Update22\<Language\> | 25 |  |
| RS Extensions Update 0.22 | Dynamics365Server90ReportingExtensionsUpdate22\<Language\> | 25 |  |
| Server Update 0.23 | Dynamics365Server90Update23\<Language\> | 25 |  |
| RS Extensions Update 0.23 | Dynamics365Server90ReportingExtensionsUpdate23\<Language\> | 25 |  |
| Server Update 0.24 | Dynamics365Server90Update24\<Language\> | 25 |  |
| RS Extensions Update 0.24 | Dynamics365Server90ReportingExtensionsUpdate24\<Language\> | 25 |  |
| Server Update 0.25 | Dynamics365Server90Update25\<Language\> | 25 |  |
| RS Extensions Update 0.25 | Dynamics365Server90ReportingExtensionsUpdate25\<Language\> | 25 |  |
| Server Update 0.26 | Dynamics365Server90Update26\<Language\> | 25 |  |
| RS Extensions Update 0.26 | Dynamics365Server90ReportingExtensionsUpdate26\<Language\> | 25 |  |
| Server Update 0.27 | Dynamics365Server90Update27\<Language\> | 25 |  |
| RS Extensions Update 0.27 | Dynamics365Server90ReportingExtensionsUpdate27\<Language\> | 25 |  |
| Server Update 0.28 | Dynamics365Server90Update28\<Language\> | 25 |  |
| RS Extensions Update 0.28 | Dynamics365Server90ReportingExtensionsUpdate28\<Language\> | 25 |  |
| Server Update 1.1 | Dynamics365Server91Update01\<Language\> | 25 |  |
| MUI Update 1.1 | Dynamics365Server91LanguagePackUpdate01\<Language\> | 45 |  |
| RS Extensions Update 1.1 | Dynamics365Server91ReportingExtensionsUpdate01\<Language\> | 25 |  |
| Server Update 0.30 | Dynamics365Server90Update30\<Language\> | 25 |  |
| RS Extensions Update 0.30 | Dynamics365Server90ReportingExtensionsUpdate30\<Language\> | 25 |  |
| Server Update 0.31 | Dynamics365Server90Update31\<Language\> | 25 |  |
| RS Extensions Update 0.31 | Dynamics365Server90ReportingExtensionsUpdate31\<Language\> | 25 |  |
| Server Update 0.32 | Dynamics365Server90Update32\<Language\> | 25 |  |
| RS Extensions Update 0.32 | Dynamics365Server90ReportingExtensionsUpdate32\<Language\> | 25 |  |
| Server Update 0.33 | Dynamics365Server90Update33\<Language\> | 25 |  |
| RS Extensions Update 0.33 | Dynamics365Server90ReportingExtensionsUpdate33\<Language\> | 25 |  |
| Server Update 0.34 | Dynamics365Server90Update34\<Language\> | 25 |  |
| RS Extensions Update 0.34 | Dynamics365Server90ReportingExtensionsUpdate34\<Language\> | 25 |  |
| Server Update 0.35 | Dynamics365Server90Update35\<Language\> | 25 |  |
| RS Extensions Update 0.35 | Dynamics365Server90ReportingExtensionsUpdate35\<Language\> | 25 |  |
| Server Update 0.37 | Dynamics365Server90Update37\<Language\> | 25 |  |
| RS Extensions Update 0.37 | Dynamics365Server90ReportingExtensionsUpdate37\<Language\> | 25 |  |
| Server Update 0.38 | Dynamics365Server90Update38\<Language\> | 25 |  |
| RS Extensions Update 0.38 | Dynamics365Server90ReportingExtensionsUpdate38\<Language\> | 25 |  |
| Server Update 0.40 | Dynamics365Server90Update40\<Language\> | 25 |  |
| RS Extensions Update 0.40 | Dynamics365Server90ReportingExtensionsUpdate40\<Language\> | 25 |  |
| Server Update 0.42 | Dynamics365Server90Update42\<Language\> | 25 |  |
| RS Extensions Update 0.42 | Dynamics365Server90ReportingExtensionsUpdate42\<Language\> | 25 |  |
| Server Update 0.43 | Dynamics365Server90Update43\<Language\> | 25 |  |
| RS Extensions Update 0.43 | Dynamics365Server90ReportingExtensionsUpdate43\<Language\> | 25 |  |
| Server Update 0.44 | Dynamics365Server90Update44\<Language\> | 25 |  |
| RS Extensions Update 0.44 | Dynamics365Server90ReportingExtensionsUpdate44\<Language\> | 25 |  |
| Server Update 0.45 | Dynamics365Server90Update45\<Language\> | 25 |  |
| RS Extensions Update 0.45 | Dynamics365Server90ReportingExtensionsUpdate45\<Language\> | 25 |  |
| Server Update 0.46 | Dynamics365Server90Update46\<Language\> | 24 | Heb language is missing |
| RS Extensions Update 0.46 | Dynamics365Server90ReportingExtensionsUpdate46\<Language\> | 24 | Heb language is missing |
| Server Update 0.47 | Dynamics365Server90Update47\<Language\> | 25 |  |
| RS Extensions Update 0.47 | Dynamics365Server90ReportingExtensionsUpdate47\<Language\> | 25 |  |
| Server Update 0.48 | Dynamics365Server90Update48\<Language\> | 25 |  |
| RS Extensions Update 0.48 | Dynamics365Server90ReportingExtensionsUpdate48\<Language\> | 25 |  |
| Server Update 0.49 | Dynamics365Server90Update49\<Language\> | 25 |  |
| RS Extensions Update 0.49 | Dynamics365Server90ReportingExtensionsUpdate49\<Language\> | 25 |  |
| Server Update 1.2 | Dynamics365Server91Update02\<Language\> | 25 |  |
| RS Extensions Update 1.2 | Dynamics365Server91ReportingExtensionsUpdate02\<Language\> | 25 |  |
| Server Update 1.3 | Dynamics365Server91Update03\<Language\> | 24 | Heb language is missing |
| RS Extensions Update 1.3 | Dynamics365Server91ReportingExtensionsUpdate03\<Language\> | 24 | Heb language is missing |
| Server Update 1.4 | Dynamics365Server91Update04\<Language\> | 23 | Cht and Fin languages are missing |
| RS Extensions Update 1.4 | Dynamics365Server91ReportingExtensionsUpdate04\<Language\> | 23 | Cht and Fin languages are missing |
| Server Update 1.5 | Dynamics365Server91Update05\<Language\> | 25 |  |
| RS Extensions Update 1.5 | Dynamics365Server91ReportingExtensionsUpdate05\<Language\> | 25 |  |
| Server Update 1.6 | Dynamics365Server91Update06\<Language\> | 24 | Plk language is missing |
| RS Extensions Update 1.6 | Dynamics365Server91ReportingExtensionsUpdate06\<Language\> | 24 | Plk language is missing |
| Server Update 1.7 | Dynamics365Server91Update07\<Language\> | 24 | Sau language is missing |
| RS Extensions Update 1.7 | Dynamics365Server91ReportingExtensionsUpdate07\<Language\> | 24 | Sau language is missing |
| Server Update 1.9 | Dynamics365Server91Update09\<Language\> | 25 |  |
| RS Extensions Update 1.9 | Dynamics365Server91ReportingExtensionsUpdate09\<Language\> | 25 |  |
| Server Update 1.10 | Dynamics365Server91Update10\<Language\> | 25 |  |
| RS Extensions Update 1.10 | Dynamics365Server91ReportingExtensionsUpdate10\<Language\> | 25 |  |
| Server Update 1.11 | Dynamics365Server91Update11\<Language\> | 25 |  |
| RS Extensions Update 1.11 | Dynamics365Server91ReportingExtensionsUpdate11\<Language\> | 25 |  |
| Server Update 1.12 | Dynamics365Server91Update12\<Language\> | 25 |  |
| RS Extensions Update 1.12 | Dynamics365Server91ReportingExtensionsUpdate12\<Language\> | 25 |  |
| Server Update 1.13 | Dynamics365Server91Update13\<Language\> | 25 |  |
| RS Extensions Update 1.13 | Dynamics365Server91ReportingExtensionsUpdate13\<Language\> | 25 |  |
| Server Update 1.14 | Dynamics365Server91Update14\<Language\> | 25 |  |
| RS Extensions Update 1.14 | Dynamics365Server91ReportingExtensionsUpdate14\<Language\> | 25 |  |
| Server Update 1.15 | Dynamics365Server91Update15\<Language\> | 25 |  |
| RS Extensions Update 1.15 | Dynamics365Server91ReportingExtensionsUpdate15\<Language\> | 25 |  |
| Server Update 1.16 | Dynamics365Server91Update16\<Language\> | 24 | Chk language missing |
| RS Extensions Update 1.16 | Dynamics365Server91ReportingExtensionsUpdate16\<Language\> | 24 | Chk language missing |
| Server Update 1.17 | Dynamics365Server91Update17\<Language\> | 25 |  |
| RS Extensions Update 1.17 | Dynamics365Server91ReportingExtensionsUpdate17\<Language\> | 25 |  |
| Server Update 1.18 | Dynamics365Server91Update18\<Language\> | 24 | Nld language missing |
| RS Extensions Update 1.18 | Dynamics365Server91ReportingExtensionsUpdate18\<Language\> | 24 | Nld language missing |
| Server Update 1.19 | Dynamics365Server91Update19\<Language\> | 25 |  |
| RS Extensions Update 1.19 | Dynamics365Server91ReportingExtensionsUpdate19\<Language\> | 25 |  |
| Server Update 1.20 | Dynamics365Server91Update20\<Language\> | 25 |  |
| RS Extensions Update 1.20 | Dynamics365Server91ReportingExtensionsUpdate20\<Language\> | 25 |  |
| Server Update 1.21 | Dynamics365Server91Update21\<Language\> | 24 | Ita language missing |
| RS Extensions Update 1.21 | Dynamics365Server91ReportingExtensionsUpdate21\<Language\> | 24 | Ita language missing |
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
| Server Update 2.13 | CRM2016ServicePack2Update13\<Language\> | 25 |  |
| RS Extensions Update 2.13 | CRM2016ReportingExtensionsServicePack2Update13\<Language\> | 25 |  |
| MUI Update 2.13 | CRM2016LanguagePackServicePack2Update13\<Language\> | 45 |  |
| Server Update 2.14 | CRM2016ServicePack2Update14\<Language\> | 25 |  |
| RS Extensions Update 2.14 | CRM2016ReportingExtensionsServicePack2Update14\<Language\> | 25 |  |
| MUI Update 2.14 | CRM2016LanguagePackServicePack2Update14\<Language\> | 45 |  |
| Server Update 2.15 | CRM2016ServicePack2Update15\<Language\> | 25 |  |
| RS Extensions Update 2.15 | CRM2016ReportingExtensionsServicePack2Update15\<Language\> | 25 |  |
| MUI Update 2.15 | CRM2016LanguagePackServicePack2Update15\<Language\> | 45 |  |
| Server Update 2.16 | CRM2016ServicePack2Update16\<Language\> | 25 |  |
| RS Extensions Update 2.16 | CRM2016ReportingExtensionsServicePack2Update16\<Language\> | 25 |  |
| MUI Update 2.16 | CRM2016LanguagePackServicePack2Update16\<Language\> | 45 |  |
| Server Update 2.17 | CRM2016ServicePack2Update17\<Language\> | 25 |  |
| RS Extensions Update 2.17 | CRM2016ReportingExtensionsServicePack2Update17\<Language\> | 25 |  |
| MUI Update 2.17 | CRM2016LanguagePackServicePack2Update17\<Language\> | 45 |  |
| Server Update 2.18 | CRM2016ServicePack2Update18\<Language\> | 25 |  |
| RS Extensions Update 2.18 | CRM2016ReportingExtensionsServicePack2Update18\<Language\> | 25 |  |
| MUI Update 2.18 | CRM2016LanguagePackServicePack2Update18\<Language\> | 45 |  |
| Server Update 2.19 | CRM2016ServicePack2Update19\<Language\> | 24 | Trk language missing |
| RS Extensions Update 2.19 | CRM2016ReportingExtensionsServicePack2Update19\<Language\> | 24 | Trk language missing |
| MUI Update 2.19 | CRM2016LanguagePackServicePack2Update19\<Language\> | 44 | Trk language missing |
| Server Update 2.21 | CRM2016ServicePack2Update21\<Language\> | 25 |  |
| RS Extensions Update 2.21 | CRM2016ReportingExtensionsServicePack2Update21\<Language\> | 25 |  |
| MUI Update 2.21 | CRM2016LanguagePackServicePack2Update21\<Language\> | 45 |  |
| Server Update 2.22 | CRM2016ServicePack2Update22\<Language\> | 25 |  |
| RS Extensions Update 2.22 | CRM2016ReportingExtensionsServicePack2Update22\<Language\> | 25 |  |
| MUI Update 2.22 | CRM2016LanguagePackServicePack2Update22\<Language\> | 45 |  |
| Server Update 2.23 | CRM2016ServicePack2Update23\<Language\> | 25 |  |
| RS Extensions Update 2.23 | CRM2016ReportingExtensionsServicePack2Update23\<Language\> | 25 |  |
| MUI Update 2.23 | CRM2016LanguagePackServicePack2Update23\<Language\> | 45 |  |
| Server Update 2.24 | CRM2016ServicePack2Update24\<Language\> | 25 |  |
| RS Extensions Update 2.24 | CRM2016ReportingExtensionsServicePack2Update24\<Language\> | 25 |  |
| MUI Update 2.24 | CRM2016LanguagePackServicePack2Update24\<Language\> | 45 |  |
| Server Update 2.25 | CRM2016ServicePack2Update25\<Language\> | 25 |  |
| RS Extensions Update 2.25 | CRM2016ReportingExtensionsServicePack2Update25\<Language\> | 25 |  |
| MUI Update 2.25 | CRM2016LanguagePackServicePack2Update25\<Language\> | 45 |  |
| Server Update 2.26 | CRM2016ServicePack2Update26\<Language\> | 25 |  |
| RS Extensions Update 2.26 | CRM2016ReportingExtensionsServicePack2Update26\<Language\> | 25 |  |
| MUI Update 2.26 | CRM2016LanguagePackServicePack2Update26\<Language\> | 45 |  |
| Server Update 2.27 | CRM2016ServicePack2Update27\<Language\> | 25 |  |
| RS Extensions Update 2.27 | CRM2016ReportingExtensionsServicePack2Update27\<Language\> | 25 |  |
| MUI Update 2.27 | CRM2016LanguagePackServicePack2Update27\<Language\> | 45 |  |
| Server Update 2.28 | CRM2016ServicePack2Update28\<Language\> | 25 |  |
| RS Extensions Update 2.28 | CRM2016ReportingExtensionsServicePack2Update28\<Language\> | 25 |  |
| MUI Update 2.28 | CRM2016LanguagePackServicePack2Update28\<Language\> | 45 |  |
| Prerequisites |  | 10 |  |
| **Total** |  | 6263 |  |

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
