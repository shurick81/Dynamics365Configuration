Import-Module ..\src\Dynamics365Configuration\RootModule.psm1 -Force
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
Install-Dynamics365Language -MediaDir C:\Install\CRM\Dynamics365Server90LanguagePackSve

#Install-Dynamics365Server `
#    -MediaDir C:\Install\CRM\CRM2016 `
#    -LicenseKey WCPQN-33442-VH2RQ-M4RKF-GXYH4 `
#    -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
#    -CreateDatabase `
#    -SqlServer DB01\SPIntra01 `
#    -PrivUserGroup "CN=CRM01PrivUserGroup,CN=Users,DC=contoso,DC=local" `
#    -SQLAccessGroup "CN=CRM01SQLAccessGroup,CN=Users,DC=contoso,DC=local" `
#    -UserGroup "CN=CRM01UserGroup,CN=Users,DC=contoso,DC=local" `
#    -ReportingGroup "CN=CRM01ReportingGroup,CN=Users,DC=contoso,DC=local" `
#    -PrivReportingGroup "CN=CRM01PrivReportingGroup,CN=Users,DC=contoso,DC=local" `
#    -CrmServiceAccount $CRMServiceAccountCredential `
#    -DeploymentServiceAccount $DeploymentServiceAccountCredential `
#    -SandboxServiceAccount $SandboxServiceAccountCredential `
#    -VSSWriterServiceAccount $VSSWriterServiceAccountCredential `
#    -AsyncServiceAccount $AsyncServiceAccountCredential `
#    -MonitoringServiceAccount $MonitoringServiceAccountCredential `
#    -CreateWebSite `
#    -WebSitePort 5555 `
#    -WebSiteUrl https://CRM01.contoso.local `
#    -Organization "Contoso Ltd." `
#    -OrganizationUniqueName Contoso `
#    -BaseISOCurrencyCode SEK `
#    -BaseCurrencyName "Svensk krona" `
#    -BaseCurrencySymbol kr `
#    -BaseCurrencyPrecision 2 `
#    -OrganizationCollation Latin1_General_CI_AI `
#    -ReportingUrl http://db01/ReportServer_SPIntra01 `
#    -InstallAccount $CRMInstallAccountCredential
#Install-Dynamics365Language -MediaDir C:\Install\CRM\CRM2016LanguagePackSve
#Install-Dynamics365Update -MediaDir C:\Install\CRM\CRM2016ServicePack2Update02 -InstallAccount $CRMInstallAccountCredential