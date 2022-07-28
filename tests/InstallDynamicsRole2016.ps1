$dbHostName = $env:VMDEVOPSSTARTER_DBHOST;
if ( !$dbHostName ) { $dbHostName = $env:COMPUTERNAME }
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
$domainName = (Get-WmiObject Win32_ComputerSystem).Domain;

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
    Save-Dynamics365Resource -Resource CRM2016LanguagePackNor -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackNor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016LanguagePackNor ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016LanguagePackNor, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ServicePack1Enu -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack1Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ServicePack1Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ServicePack1Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ServicePack2Update28Enu -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack2Update28Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ServicePack2Update28Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ServicePack2Update28Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ReportingExtensionsServicePack2Update28Enu -TargetDirectory C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016LanguagePackServicePack2Update28Nor -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor, test is not OK";
    Exit 1;
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME.$domainName with dbHostName=$dbHostName parameter";
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $dbHostName )
        Write-Host "Invoked, starting execution";
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
        $DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
        $SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
        $VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
        $AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
        $MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
        Write-Host "Creating Dynamics admin db on $dbHostName";
        Install-Dynamics365Server `
            -MediaDir C:\Install\Dynamics\CRM2016RTMEnu `
            -CreateDatabase `
            -ServerRoles BackEnd, DeploymentAdministration `
            -SqlServer $dbHostName\SQLInstance01 `
            -Patch C:\Install\Dynamics\CRM2016ServicePack1Enu\Server_KB3154952_amd64_1033.msp `
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
            -ReportingUrl http://$dbHostName/ReportServer_SSRS `
            -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput;
    } -ArgumentList $dbHostName;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}

$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion -ne [version]"8.0.0.1088" ) {
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
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate810InstallLog.txt
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion -ne [version]"8.1.0.359" ) {
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
if( Test-Path "c:\tmp\Dynamics365ServerUpdate810InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate810InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate810InstallLog.txt is not found"
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update28Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion -ne [version]"8.2.28.11" ) {
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
if( Test-Path "c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt is not found"
    Exit 1;
}

try {
    Install-Dynamics365Language -MediaDir C:\Install\Dynamics\CRM2016LanguagePackNor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524DC1-1414-0080-8121-88490F4D5549}" }
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}
if ( -not ( Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue ) )
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}

try {
    Install-Dynamics365LanguageUpdate -MediaDir C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{0C524DC1-1414-0080-8121-88490F4D5549}" }
Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
if ( ([version]$currentProductInstalled.DisplayVersion).ToString(3) -eq "8.2.28" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\CRM2016RTMEnu\SrsDataConnector";
        $patchPath = "C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu\Srs_KB3154952_amd64_1033.msp";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016RTMEnu\SrsDataConnector";
        $patchPath = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu\Srs_KB3154952_amd64_1033.msp";
    }
    Write-Host "Invoking command on $dbHostName.$domainName";
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir, $patchPath )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime;
        Install-Dynamics365ReportingExtensions `
            -MediaDir $mediaDir `
            -InstanceName SSRS `
            -Patch $patchPath `
            -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
            -AutoGroupManagementOff `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt
    } -ArgumentList $mediaDir, $patchPath;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-1409-0080-BFEE-D90853535253}" }
} else {
    $installedProduct = Get-WmiObject Win32_Product -ComputerName $dbHostName -Credential $CRMInstallAccountCredential | ? { $_.IdentifyingNumber -eq "{0C524D71-141D-0080-BFEE-D90853535253}" }
}
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}
$testScriptBlock = {
    Test-Path "c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt";
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $testResponse = Invoke-Command $testScriptBlock
} else {
    $testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP
}
if ( $testResponse )
{
    Write-Output "File c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt is not found"
    Exit 1;
}
$installedVersion = Get-Dynamics365ReportingExtensionsVersion;
if ( $installedVersion.ToString(3) -ne "8.0.0" ) {
    Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsUpdate9028InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365ReportingExtensionsUpdate";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedVersion = Get-Dynamics365ReportingExtensionsVersion;
if ( $installedVersion.ToString(3) -ne "8.2.28" ) {
    Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
    Exit 1;
}

# Testing idempotence
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
    Save-Dynamics365Resource -Resource CRM2016LanguagePackNor -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackNor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016LanguagePackNor ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016LanguagePackNor, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ServicePack1Enu -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack1Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ServicePack1Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ServicePack1Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ServicePack2Update28Enu -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack2Update28Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ServicePack2Update28Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ServicePack2Update28Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ReportingExtensionsServicePack2Update28Enu -TargetDirectory C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016LanguagePackServicePack2Update28Nor -TargetDirectory C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor, test is not OK";
    Exit 1;
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME.$domainName with dbHostName=$dbHostName parameter";
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $dbHostName )
        Write-Host "Invoked, starting execution";
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
        $DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
        $SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
        $VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
        $AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
        $MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
        Write-Host "Creating Dynamics admin db on $dbHostName";
        Install-Dynamics365Server `
            -MediaDir C:\Install\Dynamics\CRM2016RTMEnu `
            -CreateDatabase `
            -ServerRoles BackEnd, DeploymentAdministration `
            -SqlServer $dbHostName\SQLInstance01 `
            -Patch C:\Install\Dynamics\CRM2016ServicePack1Enu\Server_KB3154952_amd64_1033.msp `
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
            -ReportingUrl http://$dbHostName/ReportServer_SSRS `
            -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput;
    } -ArgumentList $dbHostName;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}

$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion -ne [version]"8.2.28.11" ) {
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

# Idempotence of this block fails
#try {
#    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
#        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
#        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1Enu `
#            -LogFilePath c:\tmp\Dynamics365ServerUpdate810InstallLog.txt
#    }
#} catch {
#    Write-Host $_.Exception.Message -ForegroundColor Red;
#    Exit 1;
#}
#$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
#if ( $msCRMRegistryValues ) {
#    $installedVersion = Get-Dynamics365ServerVersion;
#    if ( $installedVersion -ne [version]"8.2.28.11" ) {
#        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
#        Exit 1;
#    }
#    $installedLanguage = Get-Dynamics365ServerLanguage;
#    if ( $installedLanguage -ne 1033 ) {
#        Write-Host "Incorrect language is installed: $installedLanguage";
#        Exit 1;
#    }
#    Write-Host "Test OK";
#} else {
#    Write-Host "HKLM:\SOFTWARE\Microsoft\MSCRM registry key is not found";
#    Exit 1;
#}
#if( Test-Path "c:\tmp\Dynamics365ServerUpdate810InstallLog.txt" )
#{
#    Write-Output "File c:\tmp\Dynamics365ServerUpdate810InstallLog.txt is found, test OK"
#} else {
#    Write-Output "File c:\tmp\Dynamics365ServerUpdate810InstallLog.txt is not found"
#    Exit 1;
#}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update28Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion -ne [version]"8.2.28.11" ) {
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
if( Test-Path "c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt is not found"
    Exit 1;
}

try {
    Install-Dynamics365Language -MediaDir C:\Install\Dynamics\CRM2016LanguagePackNor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524DC1-1414-0080-8121-88490F4D5549}" }
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}
if ( -not ( Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue ) )
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}

try {
    Install-Dynamics365LanguageUpdate -MediaDir C:\Install\Dynamics\CRM2016LanguagePackServicePack2Update28Nor
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{0C524DC1-1414-0080-8121-88490F4D5549}" }
Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
if ( ([version]$currentProductInstalled.DisplayVersion).ToString(3) -eq "8.2.28" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\CRM2016RTMEnu\SrsDataConnector";
        $patchPath = "C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu\Srs_KB3154952_amd64_1033.msp";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016RTMEnu\SrsDataConnector";
        $patchPath = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu\Srs_KB3154952_amd64_1033.msp";
    }
    Write-Host "Invoking command on $dbHostName.$domainName";
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir, $patchPath )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime;
        Install-Dynamics365ReportingExtensions `
            -MediaDir $mediaDir `
            -InstanceName SSRS `
            -Patch $patchPath `
            -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
            -AutoGroupManagementOff `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt
    } -ArgumentList $mediaDir, $patchPath;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-1409-0080-BFEE-D90853535253}" }
} else {
    $installedProduct = Get-WmiObject Win32_Product -ComputerName $dbHostName -Credential $CRMInstallAccountCredential | ? { $_.IdentifyingNumber -eq "{0C524D71-141D-0080-BFEE-D90853535253}" }
}
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}
$testScriptBlock = {
    Test-Path "c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt";
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $testResponse = Invoke-Command $testScriptBlock
} else {
    $testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP
}
if ( $testResponse )
{
    Write-Output "File c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt is not found"
    Exit 1;
}
$installedVersion = Get-Dynamics365ReportingExtensionsVersion;
if ( $installedVersion.ToString(3) -ne "8.2.28" ) {
    Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Enu";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsUpdate9028InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365ReportingExtensionsUpdate";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedVersion = Get-Dynamics365ReportingExtensionsVersion;
if ( $installedVersion.ToString(3) -ne "8.2.28" ) {
    Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
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
        $MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
        Write-Host "Joining Dynamics config db on $dbHostName";
        Install-Dynamics365Server `
            -MediaDir C:\Install\Dynamics\CRM2016RTMEnu `
            -ServerRoles FrontEnd `
            -SqlServer $dbHostName\SQLInstance01 `
            -CrmServiceAccount $CRMServiceAccountCredential `
            -MonitoringServiceAccount $MonitoringServiceAccountCredential `
            -LogFilePath c:\tmp\Dynamics365ServerInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $dbHostName;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}

Exit 0;
