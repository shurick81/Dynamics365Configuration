# Dynamics365Configuration module change log

## v1.4

* Breaking change: Install-Dynamics365Server does not support -InstallAccount parameter.
* Breaking change: Install-Dynamics365ReportingExtension does not support -InstallAccount parameter.
* Fixing issue with updated SQL resource checksums

N/A

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
