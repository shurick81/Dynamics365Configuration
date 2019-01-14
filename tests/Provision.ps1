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
try {
    Save-Dynamics365Resource -Resource Dynamics365Server90 -TargetDirectory C:\Install\Dynamics\Dynamics365Server90
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90 ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90, test is not OK";
    Exit 1;
}
try {
    Save-Dynamics365Resource -Resource Dynamics365Server90LanguagePackSve -TargetDirectory C:\Install\Dynamics\Dynamics365Server90LanguagePackSve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90LanguagePackSve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90LanguagePackSve, test is not OK";
    Exit 1;
}

try {
    Install-Dynamics365Server `
    -MediaDir C:\Install\Dynamics\Dynamics365Server90 `
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
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$testScriptBlock = {
    try {
        Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
        if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
            $CrmOrganization = Get-CrmOrganization;
            $CrmOrganization.Version;
        } else {
            "Could not load Microsoft.Crm.PowerShell PSSnapin";
        }
    } catch {
        $_.Exception.Message;
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $testResponse -eq "9.0.2.3034" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
try {
    Install-Dynamics365Language -MediaDir C:\Install\Dynamics\Dynamics365Server90LanguagePackSve    
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524DC1-141D-0090-8121-88490F4D5549}" }
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}
# Use that for testing language pack installation
#if ( -not ( Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue ) )
#{
#    Add-PSSnapin Microsoft.Crm.PowerShell
#    $RemoveSnapInWhenDone = $True
#}
#Write-Host "$(Get-Date) Starting New-CrmOrganization";
#$importJobId = New-CrmOrganization -Name ORGLANG1053 -Credential $CRMInstallAccountCredential -DwsServerUrl "http://$env:COMPUTERNAME`:5555/XrmDeployment/2011/deployment.svc" -DisplayName "Organization for testing 1053 language" -SqlServerName $dbHostName\SPIntra01 -SrsUrl http://$dbHostName/ReportServer_SPIntra01;
#While ( $operationStatus.State -ne "Completed" )
#{
#    $operationStatus = Get-CrmOperationStatus -OperationId $importJobId
#    Write-Host "$(Get-Date) operationStatus.State is $($operationStatus.State), Waiting until CRM installation job is done";
#    Sleep 60;
#}
#if( $RemoveSnapInWhenDone )
#{
#    Remove-PSSnapin Microsoft.Crm.PowerShell
#}

#try {
#    Save-Dynamics365Resource -Resource CRM2016 -TargetDirectory C:\Install\Dynamics\CRM2016
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}
#try {
#    Save-Dynamics365Resource -Resource CRM2016LanguagePackSve -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackSve
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}
#try {
#    Save-Dynamics365Resource -Resource CRM2016ServicePack2Update02 -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack2Update02
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}
#try {
#    Install-Dynamics365Server `
#        -MediaDir C:\Install\Dynamics\CRM2016 `
#        -LicenseKey WCPQN-33442-VH2RQ-M4RKF-GXYH4 `
#        -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
#        -CreateDatabase `
#        -SqlServer $dbHostName\SPIntra01 `
#        -PrivUserGroup "CN=CRM01PrivUserGroup,OU=CRM groups,DC=contoso,DC=local" `
#        -SQLAccessGroup "CN=CRM01SQLAccessGroup,OU=CRM groups,DC=contoso,DC=local" `
#        -UserGroup "CN=CRM01UserGroup,OU=CRM groups,DC=contoso,DC=local" `
#        -ReportingGroup "CN=CRM01ReportingGroup,OU=CRM groups,DC=contoso,DC=local" `
#        -PrivReportingGroup "CN=CRM01PrivReportingGroup,OU=CRM groups,DC=contoso,DC=local" `
#        -CrmServiceAccount $CRMServiceAccountCredential `
#        -DeploymentServiceAccount $DeploymentServiceAccountCredential `
#        -SandboxServiceAccount $SandboxServiceAccountCredential `
#        -VSSWriterServiceAccount $VSSWriterServiceAccountCredential `
#        -AsyncServiceAccount $AsyncServiceAccountCredential `
#        -MonitoringServiceAccount $MonitoringServiceAccountCredential `
#        -CreateWebSite `
#        -WebSitePort 5555 `
#        -WebSiteUrl https://$env:COMPUTERNAME.contoso.local `
#        -Organization "Contoso Ltd." `
#        -OrganizationUniqueName Contoso `
#        -BaseISOCurrencyCode SEK `
#        -BaseCurrencyName "Svensk krona" `
#        -BaseCurrencySymbol kr `
#        -BaseCurrencyPrecision 2 `
#        -OrganizationCollation Latin1_General_CI_AI `
#        -ReportingUrl http://$dbHostName/ReportServer_SPIntra01 `
#        -InstallAccount $CRMInstallAccountCredential
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}
#try {
#    Install-Dynamics365Language -MediaDir C:\Install\Dynamics\CRM2016LanguagePackSve
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}
#try {
#    #Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update02 -InstallAccount $CRMInstallAccountCredential
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}

Exit 0;
