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

$domainName = (Get-WmiObject Win32_ComputerSystem).Domain;

try {
    Save-Dynamics365Resource -Resource Dynamics365Server90RTMEnu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90RTMEnu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90RTMEnu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90RTMEnu, test is not OK";
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
    Save-Dynamics365Resource -Resource Dynamics365Server90Update03Enu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90Update03Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90Update03Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90Update03Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource Dynamics365Server90ReportingExtensionsUpdate03Enu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate03Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate03Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate03Enu, test is not OK";
    Exit 1;
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME with dbHostName=$dbHostName parameter";
    Invoke-Command $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $dbHostName )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
        $CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
        $DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
        $SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
        $VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
        $AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
        $MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
        Write-Host "Creating new organization db on $dbHostName";
        Install-Dynamics365Server `
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
            -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
            -CreateDatabase `
            -SqlServer $dbHostName\SQLInstance01 `
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
            -ReportingUrl http://$dbHostName/ReportServer_RSInstance01
    } -ArgumentList $dbHostName;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
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
        Exit 1;
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
    Write-Host "Invoking command on $env:COMPUTERNAME with dbHostName=$dbHostName parameter";
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        Invoke-Command "$dbHostName.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
            Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
            Install-Dynamics365ReportingExtensions `
                -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector `
                -InstanceName SQLInstance01
        }
    } else {
        Invoke-Command "$dbHostName.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
            param( $fileShareHost )
            Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
            Install-Dynamics365ReportingExtensions `
                -MediaDir \\$fileShareHost\c$\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector `
                -InstanceName SQLInstance01
        } -ArgumentList $env:COMPUTERNAME;
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-1409-0090-BFEE-D90853535253}" }
} else {
    $installedProduct = Get-WmiObject Win32_Product -ComputerName $dbHostName -Credential $CRMInstallAccountCredential | ? { $_.IdentifyingNumber -eq "{0C524D71-1409-0090-BFEE-D90853535253}" }
}
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}

try {
    Install-Dynamics365Language -MediaDir C:\Install\Dynamics\Dynamics365Server90LanguagePackSve;
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

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update03Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate903InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    }
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
        Exit 1;
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $testResponse -eq "9.0.3.7" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate903InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate903InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate903InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate03Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate03Enu";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Update";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$currentProductInstalled = Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "MSCRM SRS Data Connector" }
}
Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0003.0007" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

Exit 0;
