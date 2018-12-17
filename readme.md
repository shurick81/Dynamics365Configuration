# Introduction

A module to ease infrastructure as code tasks for Dynamics 365.

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

The resource for downloading, possible values are [Dynamics365Server90,VisualCPlusPlusRuntime,VisualCPlusPlus2010Runtime,SQLNCli2012SP4,SQLSysClrTypes2016,SharedManagementObjects2016,MSODBCSQL,Dynamics365Server90LanguagePack<Language>,CRM2016,SQLNCli2018R2,SQLSysClrTypes2012,SharedManagementObjects2012,ReportViewer2012,CRM2016LanguagePack<Language>,CRM2016Update01,CRM2016ServicePack1,CRM2016ServicePack1Update01,CRM2016ServicePack2,CRM2016ServicePack2Update01,CRM2016ServicePack2Update02]

#### -TargetDirectory

The directory path where the files or directories will be saved.

### Examples

Loading all known resources to the current directory:

```PowerShell
Save-Dynamics365Resource
```

Loading CRM2016ServicePack2Update02 to current directory:

```PowerShell
Save-Dynamics365Resource -Resource CRM2016ServicePack2Update02
```

Loading all known resources to the specified directory:

```PowerShell
Save-Dynamics365Resource -TargetDirectory c:\CRMResources
```

Loading CRM2016LanguagePackRus to the specified directory:

```PowerShell
Save-Dynamics365Resource -Resource CRM2016LanguagePackRus c:\CRMResources\CRM2016ServicePack2Update02
```

## Install-Dynamics365Prerequisites

Installs one specified or all the software prerequisites.

### Syntax

```PowerShell
Install-Dynamics365Prerequisites
    [-Prerequisite <Dymanics365PrerequisiteName>]
    [-DynamicsPrerequisiteFilePath <string>]
```

### Parameters

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
Install-Dynamics365Prerequisites -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\CRM
```

or

```PowerShell
Install-Dynamics365Prerequisites -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\CRM\SQLNCli2012SP4
```

or

```PowerShell
Install-Dynamics365Prerequisites -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath C:\Install\CRM\SQLNCli2012SP4\sqlncli.msi
```

## Install-Dynamics365Server

Installs Dynamics 365 Server with new or existing organization.

### Syntax

```PowerShell
Install-Dynamics365Server
    -MediaDir <string>
    -LicenseKey <string>
    -InstallDir <string>
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
    -BaseISOCurrencyCode <string>
    -BaseCurrencyName <string>
    -BaseCurrencySymbol <string>
    -BaseCurrencyPrecision <int>
    -OrganizationCollation <string>
    -ReportingUrl <string>
    [-SQM <switch>]
    [-MUOptin <switch>]
    [-Reboot <switch>]
    [-InstallAccount <pscredential>]
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
Install-Dynamics365Server `
    -MediaDir C:\Install\CRM\Dynamics365Server90 `
    -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
    -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
    -CreateDatabase `
    -SqlServer DB01\SPIntra01 `
    -PrivUserGroup "CN=CRM01PrivUserGroup,CN=Users,DC=contoso,DC=local" `
    -SQLAccessGroup "CN=CRM01SQLAccessGroup,CN=Users,DC=contoso,DC=local" `
    -UserGroup "CN=CRM01UserGroup,CN=Users,DC=contoso,DC=local" `
    -ReportingGroup "CN=CRM01ReportingGroup,CN=Users,DC=contoso,DC=local" `
    -PrivReportingGroup "CN=CRM01PrivReportingGroup,CN=Users,DC=contoso,DC=local" `
    -CrmServiceAccount $CRMServiceAccountCredential `
    -DeploymentServiceAccount $DeploymentServiceAccountCredential `
    -SandboxServiceAccount $SandboxServiceAccountCredential `
    -VSSWriterServiceAccount $VSSWriterServiceAccountCredential `
    -AsyncServiceAccount $AsyncServiceAccountCredential `
    -MonitoringServiceAccount $MonitoringServiceAccountCredential `
    -CreateWebSite `
    -WebSitePort 5555 `
    -WebSiteUrl https://CRM01.contoso.local `
    -Organization "Contoso Ltd." `
    -OrganizationUniqueName Contoso `
    -BaseISOCurrencyCode SEK `
    -BaseCurrencyName "Svensk krona" `
    -BaseCurrencySymbol kr `
    -BaseCurrencyPrecision 2 `
    -OrganizationCollation Latin1_General_CI_AI `
    -ReportingUrl http://db01/ReportServer_SPIntra01 `
    -InstallAccount $CRMInstallAccountCredential
```

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
Install-Dynamics365Language -MediaDir C:\Install\CRM\Dynamics365Server90LanguagePackSve
```

## Install-Dynamics365Update

Installs Dynamics 365 Server update.

### Syntax

```PowerShell
Install-Dynamics365Update
    [-MediaDir] <string>
    [-InstallAccount <pscredential>]
```

### Parameters

#### MediaDir

Specifies the location of the Dynamics 365 Server update installation files.

#### InstallAccount

An account that has permissions to install the software and update the database. If not specified, the current account is used. If specified, CredSSP must be configured for invoking scripts locally on the machine with altered credential.

### Examples

```PowerShell
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
Install-Dynamics365Update -MediaDir C:\Install\CRM\Dynamics365Server90LanguagePackSve -InstallAccount $CRMInstallAccountCredential
```
