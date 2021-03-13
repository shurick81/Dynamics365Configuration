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
    Save-Dynamics365Resource -Resource Dynamics365Server90Update26Enu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90Update26Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90Update26Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90Update26Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource Dynamics365Server90ReportingExtensionsUpdate26Enu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate26Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate26Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate26Enu, test is not OK";
    Exit 1;
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME.$domainName with dbHostName=$dbHostName parameter";
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $dbHostName )
        Write-Host "Invoked, starting execution";
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
            -ReportingUrl http://$dbHostName/ReportServer_SSRS `
            -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
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
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( ([version]$testResponse).ToString(3) -eq "9.0.2" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector";
    }
    Write-Host "Invoking command on $dbHostName.$domainName";
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime;
        Install-Dynamics365ReportingExtensions `
            -MediaDir $mediaDir `
            -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
            -AutoGroupManagementOff `
            -InstanceName SSRS `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
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
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update26Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate926InstallLog.txt `
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
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( ([version]$testResponse).ToString(3) -eq "9.0.26" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate926InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate926InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate926InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate26Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate26Enu";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsUpdate9026InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Update";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedVersion = Get-Dynamics365ReportingExtensionsVersion;
if ( $installedVersion.ToString(3) -ne "9.0.26" ) {
    Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
    Exit 1;
}

Exit 0;
