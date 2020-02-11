$dbHostName = $env:VMDEVOPSSTARTER_DBHOST;
if ( !$dbHostName ) { $dbHostName = $env:COMPUTERNAME }
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );

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
    Save-Dynamics365Resource -Resource Dynamics365Server90Update11Enu -TargetDirectory C:\Install\Dynamics\Dynamics365Server90Update11Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server90Update11Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server90Update11Enu, test is not OK";
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
        Write-Host "Creating Dynamics admin db on $dbHostName";
        Install-Dynamics365Server `
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
            -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
            -CreateDatabase `
            -ServerRoles BackEnd, DeploymentAdministration `
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
            -ReportingUrl http://$dbHostName/ReportServer_RSInstance01 `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $dbHostName;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
If ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion -ne [version]"9.0.2.3034" ) {
        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
        Exit 1;
    }
    $installedLanguage = Get-Dynamics365ServerLanguage;
    if ( $installedLanguage -ne 1033 ) {
        Write-Host "Incorrect language is installed: $installedLanguage";
        Exit 1;
    }
    Write-Host "Test OK";
} else {
    Write-Host "HKLM:\SOFTWARE\Microsoft\MSCRM registry key is not found";
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
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update11Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate9011InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM;
$installedVersion = Get-Dynamics365ServerVersion;
if ( $installedVersion.ToString(3) -ne "9.0.11" ) {
    Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
    Exit 1;
}

$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
If ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion.ToString(3) -ne "9.0.11" ) {
        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
        Exit 1;
    }
    Write-Host "Test OK";
} else {
    Write-Host "HKLM:\SOFTWARE\Microsoft\MSCRM registry key is not found";
    Exit 1;
}

Exit 0;
