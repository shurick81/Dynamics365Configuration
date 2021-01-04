Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1
$dbHostName = $env:VMDEVOPSSTARTER_DBHOST;
if ( !$dbHostName ) { $dbHostName = $env:COMPUTERNAME }
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
$DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
$SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
$VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
$AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
$MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );

try {
    Save-Dynamics365Resource -Resource CRM2016RTMEnu -TargetDirectory C:\Install\Dynamics\CRM2016RTMEnu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016RTMEnu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016RTMEnu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ServicePack2Update23Enu -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack2Update23Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
try {
    Install-Dynamics365Server `
        -MediaDir C:\Install\Dynamics\CRM2016RTMEnu `
        -CreateDatabase `
        -SqlServer $dbHostName\SQLInstance01 `
        -PrivUserGroup "CN=CRM01PrivUserGroup00,OU=CRM groups 00,DC=contoso,DC=local" `
        -SQLAccessGroup "CN=CRM01SQLAccessGroup00,OU=CRM groups 00,DC=contoso,DC=local" `
        -UserGroup "CN=CRM01UserGroup00,OU=CRM groups 00,DC=contoso,DC=local" `
        -ReportingGroup "CN=CRM01ReportingGroup00,OU=CRM groups 00,DC=contoso,DC=local" `
        -PrivReportingGroup "CN=CRM01PrivReportingGroup00,OU=CRM groups 00,DC=contoso,DC=local" `
        -AutoGroupManagementOff `
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
        -ReportingUrl http://$dbHostName/ReportServer_SSRS
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$testScriptBlock = {
    try {
        Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
        if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
            $crmServer = Get-CrmServer $env:COMPUTERNAME;
            $crmServer.Version;
        } else {
            "Could not load Microsoft.Crm.PowerShell PSSnapin";
        }
    } catch {
        $_.Exception.Message;
        Exit 1;
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock;
if ( ([version]$testResponse).ToString(3) -eq "8.0.0" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    Install-Dynamics365ReportingExtensions `
        -MediaDir C:\Install\Dynamics\CRM2016RTMEnu\SrsDataConnector `
        -AutoGroupManagementOff
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-1409-0080-BFEE-D90853535253}" }
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}

try {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update23Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$testScriptBlock = {
    try {
        Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
        if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
            $crmServer = Get-CrmServer $env:COMPUTERNAME;
            $crmServer.Version;
        } else {
            "Could not load Microsoft.Crm.PowerShell PSSnapin";
        }
    } catch {
        $_.Exception.Message;
        Exit 1;
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock
if ( ([version]$testResponse).ToString(3) -eq "8.2.2" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

Exit 0;
