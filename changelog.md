# Dynamics365Configuration module change log

## Unreleased

* VisualCPlusPlus2010Runtime resource file hash updated (by MS)

## 2.8.0

* New Dynamics 365 updates (145 new downloadables in total):

  * Dynamics365Server90Update27\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate27\<Language\>
  * CRM2016ServicePack2Update28\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update28\<Language\>
  * CRM2016LanguagePackServicePack2Update28\<Language\>

## 2.7.0

* New Dynamics 365 updates (195 new downloadables in total):

  * Dynamics365Server90Update25\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate25\<Language\>
  * Dynamics365Server90Update26\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate26\<Language\>
  * CRM2016ServicePack2Update27\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update27\<Language\>
  * CRM2016LanguagePackServicePack2Update27\<Language\>

## 2.6.0

* Bug #46 fixed: non-ascii characters encoding in `Install-Dynamics365Server` and `Install-Dynamics365ReportingExtensions`

## 2.5.0

* New Dynamics 365 updates (145 new downloadables in total):

  * Dynamics365Server90Update24\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate24\<Language\>
  * CRM2016ServicePack2Update26\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update26\<Language\>
  * CRM2016LanguagePackServicePack2Update26\<Language\>

## 2.4.0

* Default log location is changed to `%AppData%\Microsoft\MSCRM\Logs` for  `Install-Dynamics365Server`, `Install-Dynamics365ReportingExtensions`, `Install-Dynamics365Update`, `Install-Dynamics365ReportingExtensionsUpdate` and `Install-Dynamics365LanguageUpdate` commands

* `Install-Dynamics365Server` command fixes

  * issue with AutoGroupManagementOff not working if either of groups specified in parameters
  * issue #45: last log file lines missing in the command output

* `Install-Dynamics365Update` command fixes

  * issue #42: no exception when installing the update that is already installed
  * issue #45: last log file lines missing in the command output

* `Install-Dynamics365ReportingExtensionsUpdate` command fixes

  * issue #43: not running RS extensions update if it already installed

* `Install-Dynamics365ReportingExtensions` command fixes

  * issue #45: last log file lines missing in the command output

## 2.3.0

* New Dynamics 365 updates (290 new downloadables in total):

  * Dynamics365Server90Update22\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate22\<Language\>
  * CRM2016ServicePack2Update24\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update24\<Language\>
  * CRM2016LanguagePackServicePack2Update24\<Language\>
  * Dynamics365Server90Update23\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate23\<Language\>
  * CRM2016ServicePack2Update25\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update25\<Language\>
  * CRM2016LanguagePackServicePack2Update25\<Language\>

* Improvements in Install-Dynamics365Server

  * Roles added on the server with Dynamics already installed
  * Automatically find trial license key if LicenseKey parameter is not used

* Showing total time elapsed in `Install-Dynamics365Server`, `Install-Dynamics365ReportingExtensions`, `Install-Dynamics365Update`, `Install-Dynamics365ReportingExtensionsUpdate` and `Install-Dynamics365LanguageUpdate`

## 2.2.0

* Displayed elapsed time for long running operations.
* New parameter in Install-Dynamics365Server: AutoGroupManagementOff
* New parameter in Install-Dynamics365ReportingExtensions: AutoGroupManagementOff
* New parameter in Install-Dynamics365Server: OU

## 2.1.0

* New Dynamics 365 updates (1060 new downloadables in total):

  * Dynamics365Server90Update14\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate14\<Language\>
  * CRM2016ServicePack2Update16\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update16\<Language\>
  * CRM2016LanguagePackServicePack2Update16\<Language\>
  * Dynamics365Server90Update15\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate15\<Language\>
  * CRM2016ServicePack2Update17\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update17\<Language\>
  * CRM2016LanguagePackServicePack2Update17\<Language\>
  * Dynamics365Server90Update16\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate16\<Language\>
  * CRM2016ServicePack2Update18\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update18\<Language\>
  * CRM2016LanguagePackServicePack2Update18\<Language\>
  * Dynamics365Server90Update17\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate17\<Language\>
  * CRM2016ServicePack2Update19\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update19\<Language\>
  * CRM2016LanguagePackServicePack2Update19\<Language\>
  * Dynamics365Server90Update18\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate18\<Language\>
  * Dynamics365Server90Update19\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate19\<Language\>
  * CRM2016ServicePack2Update21\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update21\<Language\>
  * CRM2016LanguagePackServicePack2Update21\<Language\>
  * Dynamics365Server90Update20\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate20\<Language\>
  * CRM2016ServicePack2Update22\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update2\<Language\>
  * CRM2016LanguagePackServicePack2Update22\<Language\>
  * Dynamics365Server90Update21\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate21\<Language\>
  * CRM2016ServicePack2Update23\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update23\<Language\>
  * CRM2016LanguagePackServicePack2Update23\<Language\>

* Fixes in resources:

  * New SQLNCli2012SP4 checksum
  * New Dynamics365Server90LanguagePack\<Language\> checksum (because version 9.00.0015.0010 is published instead of old)
  * New version of SQLSysClrTypes2016 resource
  * New version of SharedManagementObjects2016 resource
  * New version of SQLNCli2008R2 resource
  * Fixed typo in the SQLNCli2008R2 name

* Dev Infrastructure Improvements: fixed Win2012R2 build after 2020 April TLS changes.

## v2.0

* Breaking changes in Install-Dynamics365ReportingExtensions

  * ConfigDBServer represents entire instance name, not just server name part
  * InstanceName represents RS instance name, not config db instance name

* New commandlets

  * Get-Dynamics365ServerLanguage
  * Get-Dynamics365ServerRole
  * Get-Dynamics365ServerVersion

* Improvements in Install-Dynamics365Server

  * ServerRoles allowing select what roles to be installed
  * Removed obligation from number of parameters: `CreateDatabase`, `SQLAccessGroup`, `PrivUserGroup`, `UserGroup`, `ReportingGroup`, `PrivReportingGroup`, `CrmServiceAccount`, `DeploymentServiceAccount`, `SandboxServiceAccount`, `VSSWriterServiceAccount`, `AsyncServiceAccount`, `MonitoringServiceAccount`, `CreateWebSite`, `WebSitePort`, `WebSiteUrl`, `Organization`, `OrganizationUniqueName`, `ReportingUrl`.

* New Dynamics 365 updates (290 new downloadables in total):

  * Dynamics365Server90Update12\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate12\<Language\>
  * CRM2016ServicePack2Update14\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update14\<Language\>
  * CRM2016LanguagePackServicePack2Update14\<Language\>
  * Dynamics365Server90Update13\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate13\<Language\>
  * CRM2016ServicePack2Update15\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update15\<Language\>
  * CRM2016LanguagePackServicePack2Update15\<Language\>

## v1.5

* Dynamics365Server90Update05Sve and CRM2016LanguagePackServicePack2Update04Lvi checksums corrected.
* New Dynamics 365 updates (290 new downloadables in total):

  * Dynamics365Server90Update10\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate10\<Language\>
  * CRM2016ServicePack2Update12\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update12\<Language\>
  * CRM2016LanguagePackServicePack2Update12\<Language\>
  * Dynamics365Server90Update11\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate11\<Language\>
  * CRM2016ServicePack2Update13\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update13\<Language\>
  * CRM2016LanguagePackServicePack2Update13\<Language\>

* New way of verifying Dynamics Server version installed: using Get-CrmServer instead of Get-CrmOrganization

## v1.4

* Breaking change: Install-Dynamics365Server does not support -InstallAccount parameter.
* Breaking change: Install-Dynamics365ReportingExtension does not support -InstallAccount parameter.
* Fixing issue with updated SQL resource checksums
    * SQLSysClrTypes2016
    * SharedManagementObjects2016
* New Dynamics 365 updates (857 new downloadables in total):

  * Dynamics365Server90Update04\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate04\<Language\>
  * Dynamics365Server90Update05\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate05\<Language\>
  * Dynamics365Server90Update06\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate06\<Language\>
  * Dynamics365Server90Update07\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate07\<Language\>
  * Dynamics365Server90Update08\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate08\<Language\>
  * Dynamics365Server90Update09\<Language\>
  * Dynamics365Server90ReportingExtensionsUpdate09\<Language\>
  * CRM2016ServicePack2Update06\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update06\<Language\>
  * CRM2016LanguagePackServicePack2Update06\<Language\>
  * CRM2016ServicePack2Update07\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update07\<Language\>
  * CRM2016LanguagePackServicePack2Update07\<Language\>
  * CRM2016ServicePack2Update08\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update08\<Language\>
  * CRM2016LanguagePackServicePack2Update08\<Language\>
  * CRM2016ServicePack2Update09\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update09\<Language\>
  * CRM2016LanguagePackServicePack2Update09\<Language\>
  * CRM2016ServicePack2Update10\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update10\<Language\>
  * CRM2016LanguagePackServicePack2Update10\<Language\>
  * CRM2016ServicePack2Update11\<Language\>
  * CRM2016ReportingExtensionsServicePack2Update11\<Language\>
  * CRM2016LanguagePackServicePack2Update11\<Language\>

## v1.3

* New resources:
  * `Dynamics365Server90Update03\<Language\>`
  * `Dynamics365Server90ReportingExtensionsUpdate03\<Language\>`
  * `CRM2016ServicePack2Update04\<Language\>`
  * `CRM2016ReportingExtensionsServicePack2Update04\<Language\>`
  * `CRM2016LanguagePackServicePack2Update04\<Language\>`
  * `CRM2016ServicePack2Update05\<Language\>`
  * `CRM2016ReportingExtensionsServicePack2Update05\<Language\>`
  * `CRM2016LanguagePackServicePack2Update05\<Language\>`
* `Install-Dynamics365ReportingExtensionsUpdate`: default log path name is `$env:Temp\DynamicsReportingExtensionsUpdateInstallationLog_$timeStamp.txt`
* `Install-Dynamics365Update`: default log file path is `$env:Temp\DynamicsUpdateInstallationLog_$timeStamp.txt`
* Corrections in readme: fixed typos in list of valid values for -Resource parameter of Save-Dynamics365Resource commandlet.

## v1.2

* `Install-Dynamics365Server`, `Install-Dynamics365ReportingExtension` and `Install-Dynamics365Update` have new parameters:
  * `LogFilePath`
  * `LogFilePullIntervalInSeconds`
  * `LogFilePullToOutput`
* `Install-Dynamics365Update` does not have `-InstallAccount` parameter.
* New commands `Install-Dynamics365ReportingExtensionUpdate` and `Install-Dynamics365LanguageUpdate`.
* Added missing resources: `CRM2016LanguagePackHrv`
* New resources:
  * `CRM2016LanguagePackUpdate01\<Language\>`
  * `CRM2016LanguagePackServicePack1\<Language\>`
  * `CRM2016LanguagePackServicePack1Update01\<Language\>`
  * `CRM2016LanguagePackServicePack2\<Language\>`
  * `CRM2016LanguagePackServicePack2Update01\<Language\>`
  * `CRM2016LanguagePackServicePack2Update02\<Language\>`
  * `CRM2016LanguagePackServicePack2Update03\<Language\>`

## v1.1

* `Install-Dynamics365Prerequisites` renamed to `Install-Dynamics365Prerequisite`
* Change in `Install-Dynamics365Server` parameters
  * `InstallDir` is not required
  * `BaseISOCurrencyCode` is not required
  * `BaseCurrencyName` is not required
  * `BaseCurrencySymbol` is not required
  * `BaseCurrencyPrecision` is not required
  * `OrganizationCollation` is not required
* A new command, `Expand-Dynamics365Resource` for extracting file resource from downloaded files.
* Refactoring
  * Adding Windows 2019 to testing platforms, which brings total number of compatible platforms to three: Windows 2012 R2, Windows Server 2016, Windows Server 2019.

## v1.0

* Reporting extensions verification using product id and language code.
* Corrected URL and checksum for Dynamics365Server90LanguagePackFra and Dynamics365Server90LanguagePackJpn.
* Added Dynamics365Server90RTMKor, Dynamics365Server90RTMRus, CRM2016RTMKor, CRM2016RTMRus and CRM2016LanguagePackEnu to Save-Dynamics365Resource -Resource
* Removing annoying notification about incorrect verb
* Added CRM2016ServicePack2Update03\<Language\> and CRM2016ReportingExtensionsServicePack2Update03\<Language\> resources
* Added iterations in Install-Dynamics365Language
* Refactoring
  * Variative test cases with many languages and windows platforms
  * In dev/test infrastructure, SQL instance renamed to SQLInstance01
  * In dev/test infrastructure, SQL Reporting Services instance renamed to RSInstance01

## v0.9

* Changed file resources names and extended resources so that it is possible to download and install native language versions of Dynamics 365 Server, not only English:
  - Dynamics365Server90 > Dynamics365Server90RTM\<Language\>
  - CRM2016 > CRM2016RTM\<Language\>
  - CRM2016Update01 > CRM2016Update01\<Language\>
  - CRM2016ServicePack1 > CRM2016ServicePack1\<Language\>
  - CRM2016ServicePack1Update01 > CRM2016ServicePack1Update01\<Language\>
  - CRM2016ServicePack2 > CRM2016ServicePack2\<Language\>
  - CRM2016ServicePack2Update01 > CRM2016ServicePack2Update01\<Language\>
  - CRM2016ServicePack2Update02 > CRM2016ServicePack2Update02\<Language\>
  - CRM2016ReportingExtensionsUpdate01 > CRM2016ReportingExtensionsUpdate01\<Language\>
  - CRM2016ReportingExtensionsServicePack1 > CRM2016ReportingExtensionsServicePack1\<Language\>
  - CRM2016ReportingExtensionsServicePack1Update01 > CRM2016ReportingExtensionsServicePack1Update01\<Language\>
  - CRM2016ReportingExtensionsServicePack2 > CRM2016ReportingExtensionsServicePack2\<Language\>
  - CRM2016ReportingExtensionsServicePack2Update01 > CRM2016ReportingExtensionsServicePack2Update01\<Language\>
  - CRM2016ReportingExtensionsServicePack2Update02 > CRM2016ReportingExtensionsServicePack2Update02\<Language\>
* Fixed language pack installation validation in case if a wrong product id is used.
* Fixed issue with using Install-Dynamics365Prerequisites for installing all prerequisites from predownloaded files.
* Corrected a mistakes in Examples chapter of Install-Dynamics365Prerequisites description in README.

## v0.8

* Fixed manifest issue that was released with module restructuring in v0.7

## v0.7

* Save-Dynamics365Resource command verifies checksum of the file download
* Install-Dynamics365Prerequisites verifies checksum of the file download
* Install-Dynamics365Prerequisites is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Prerequisites verifies installation via product ID and signals if installation failed (for automatic testing)
* Install-Dynamics365Server is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Server verifies installation via Microsoft.Crm.PowerShell snappin and signals if installation failed (for automatic testing)
* Install-Dynamics365Update is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Update verifies installation via Microsoft.Crm.PowerShell snappin and signals if installation failed (for automatic testing)
* Install-Dynamics365Language is not installing the product if it is already installed (idempotency)
* Install-Dynamics365Update verifies installation via product ID and signals if installation failed (for automatic testing)
* New commandlet: Install-Dynamics365ReportingExtensions
* New file resources: CRM2016ReportingExtensionsUpdate01, CRM20166ReportingExtensionsServicePack1, CRM20166ReportingExtensionsServicePack1Update01, CRM20166ReportingExtensionsServicePack2, CRM20166ReportingExtensionsServicePack2Update01, CRM20166ReportingExtensionsServicePack2Update02

## v0.6 Initial public release
