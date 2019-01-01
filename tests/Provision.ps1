Save-Dynamics365Resource -Resource Dynamics365Server90 -TargetDirectory C:\Istall\Dynamics\Dynamics365Server90
Save-Dynamics365Resource -Resource Dynamics365Server90LanguagePackSve -TargetDirectory C:\Istall\Dynamics\Dynamics365Server90LanguagePackSve
$dbHostName = $env:VMDEVOPSSTARTER_DBHOST;
if ( !$dbHostName ) { $dbHostName = $env:COMPUTERNAME }
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
$CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
$DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
$SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
$VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
$AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
$MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
Install-Dynamics365Server `
    -MediaDir C:\Istall\Dynamics\Dynamics365Server90 `
    -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
    -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
    -CreateDatabase `
    -SqlServer $dbHostName\SPIntra01 `
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
    -BaseISOCurrencyCode SEK `
    -BaseCurrencyName "Svensk krona" `
    -BaseCurrencySymbol kr `
    -BaseCurrencyPrecision 2 `
    -OrganizationCollation Latin1_General_CI_AI `
    -ReportingUrl http://$dbHostName/ReportServer_SPIntra01 `
    -InstallAccount $CRMInstallAccountCredential
Install-Dynamics365Language -MediaDir C:\Install\Dynamics\Dynamics365Server90LanguagePackSve

#Save-Dynamics365Resource -Resource CRM2016 -TargetDirectory C:\Istall\Dynamics\CRM2016
#Save-Dynamics365Resource -Resource CRM2016LanguagePackSve -TargetDirectory C:\Istall\Dynamics\CRM2016LanguagePackSve
#Save-Dynamics365Resource -Resource CRM2016ServicePack2Update02 -TargetDirectory C:\Istall\Dynamics\CRM2016ServicePack2Update02
#Install-Dynamics365Server `
#    -MediaDir C:\Istall\Dynamics\CRM2016 `
#    -LicenseKey WCPQN-33442-VH2RQ-M4RKF-GXYH4 `
#    -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
#    -CreateDatabase `
#    -SqlServer $dbHostName\SPIntra01 `
#    -PrivUserGroup "CN=CRM01PrivUserGroup,OU=CRM groups,DC=contoso,DC=local" `
#    -SQLAccessGroup "CN=CRM01SQLAccessGroup,OU=CRM groups,DC=contoso,DC=local" `
#    -UserGroup "CN=CRM01UserGroup,OU=CRM groups,DC=contoso,DC=local" `
#    -ReportingGroup "CN=CRM01ReportingGroup,OU=CRM groups,DC=contoso,DC=local" `
#    -PrivReportingGroup "CN=CRM01PrivReportingGroup,OU=CRM groups,DC=contoso,DC=local" `
#    -CrmServiceAccount $CRMServiceAccountCredential `
#    -DeploymentServiceAccount $DeploymentServiceAccountCredential `
#    -SandboxServiceAccount $SandboxServiceAccountCredential `
#    -VSSWriterServiceAccount $VSSWriterServiceAccountCredential `
#    -AsyncServiceAccount $AsyncServiceAccountCredential `
#    -MonitoringServiceAccount $MonitoringServiceAccountCredential `
#    -CreateWebSite `
#    -WebSitePort 5555 `
#    -WebSiteUrl https://$env:COMPUTERNAME.contoso.local `
#    -Organization "Contoso Ltd." `
#    -OrganizationUniqueName Contoso `
#    -BaseISOCurrencyCode SEK `
#    -BaseCurrencyName "Svensk krona" `
#    -BaseCurrencySymbol kr `
#    -BaseCurrencyPrecision 2 `
#    -OrganizationCollation Latin1_General_CI_AI `
#    -ReportingUrl http://$dbHostName/ReportServer_SPIntra01 `
#    -InstallAccount $CRMInstallAccountCredential
#Install-Dynamics365Language -MediaDir C:\Istall\Dynamics\CRM2016LanguagePackSve
#Install-Dynamics365Update -MediaDir C:\Istall\Dynamics\CRM2016ServicePack2Update02 -InstallAccount $CRMInstallAccountCredential