Import-Module ..\src\Dynamics365Configuration\RootModule.psm1 -Force
Save-Dynamics365Resource -Resource Dynamics365Server90 -TargetDirectory c:\Install\CRM\Dynamics365Server90
Save-Dynamics365Resource -Resource Dynamics365Server90LanguagePackSve -TargetDirectory c:\Install\CRM\Dynamics365Server90LanguagePackSve
#Save-Dynamics365Resource -Resource CRM2016 -TargetDirectory c:\Install\CRM\CRM2016
#Save-Dynamics365Resource -Resource CRM2016LanguagePackSve -TargetDirectory c:\Install\CRM\CRM2016LanguagePackSve
#Save-Dynamics365Resource -Resource CRM2016ServicePack2Update02 -TargetDirectory c:\Install\CRM\CRM2016ServicePack2Update02
Install-Dynamics365Prerequisites
