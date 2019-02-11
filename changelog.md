# Dynamics365Configuration module change log

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
