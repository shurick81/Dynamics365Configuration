$serverUpdateResource = "Dynamics365Server90Update51Enu"
$serverUpdateResource2 = "Dynamics365Server91Update26Enu"
$reportingExtensionsUpdateResource = "Dynamics365Server90ReportingExtensionsUpdate51Enu"
$reportingExtensionsUpdateResource2 = "Dynamics365Server91ReportingExtensionsUpdate26Enu"
$updatedVersion = "9.0.51"
$updatedVersion2 = "9.1.26"

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
    Save-Dynamics365Resource -Resource $serverUpdateResource -TargetDirectory C:\Install\Dynamics\$serverUpdateResource
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$serverUpdateResource ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$serverUpdateResource, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource $serverUpdateResource2 -TargetDirectory C:\Install\Dynamics\$serverUpdateResource2
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$serverUpdateResource2 ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$serverUpdateResource2, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource Dynamics365Server91LanguagePackUpdate01Sve -TargetDirectory C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource $reportingExtensionsUpdateResource -TargetDirectory C:\Install\Dynamics\$reportingExtensionsUpdateResource
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$reportingExtensionsUpdateResource ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$reportingExtensionsUpdateResource, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource $reportingExtensionsUpdateResource2 -TargetDirectory C:\Install\Dynamics\$reportingExtensionsUpdateResource2
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$reportingExtensionsUpdateResource2 ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$reportingExtensionsUpdateResource2, test is not OK";
    Exit 1;
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME.$domainName with dbHostName=$dbHostName parameter";
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $dbHostName, $serverUpdateResource )
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
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
            -CreateDatabase `
            -ServerRoles BackEnd, DeploymentAdministration `
            -SqlServer $dbHostName\SQLInstance01 `
            -Patch C:\Install\Dynamics\$serverUpdateResource `
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
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput;
        Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
        Write-Host "(Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes";
        Write-Host (Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes;
    } -ArgumentList $dbHostName, $serverUpdateResource;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion ) {
        if ( $installedVersion.ToString(3) -ne $updatedVersion ) {
            Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
            Exit 1;
        }
    } else {
        Write-Host "Version is not determined";
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
        param( $serverUpdateResource2 )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\$serverUpdateResource2 `
            -LogFilePath c:\tmp\Dynamics365ServerUpdateInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $serverUpdateResource2
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedVersion = Get-Dynamics365ServerVersion;
if ( $installedVersion ) {
    if ( $installedVersion.ToString(3) -ne $updatedVersion2 ) {
        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
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
    Install-Dynamics365LanguageUpdate -MediaDir C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{0C524DC1-141D-0090-8121-88490F4D5549}" }
Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
if ( ([version]$currentProductInstalled.DisplayVersion).ToString(3) -eq "9.1.1" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector";
        $patchPath = "C:\Install\Dynamics\$reportingExtensionsUpdateResource";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector";
        $patchPath = "\\$env:COMPUTERNAME\c$\Install\Dynamics\$reportingExtensionsUpdateResource";
    }
    Write-Host "Invoking command on $dbHostName.$domainName";
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir, $patchPath )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime;
        Install-Dynamics365ReportingExtensions `
            -MediaDir $mediaDir `
            -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
            -AutoGroupManagementOff `
            -InstanceName SSRS `
            -Patch $patchPath `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir, $patchPath;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
Write-Host "testing RS installation"
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
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedVersion = Get-Dynamics365ReportingExtensionsVersion;
} else {
    $installedVersion = Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Get-Dynamics365ReportingExtensionsVersion;
    }
}
$installedVersion.ToString(3);
if ( $installedVersion ) {
    if ( $installedVersion.ToString(3) -ne $updatedVersion ) {
        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\$reportingExtensionsUpdateResource2";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\$reportingExtensionsUpdateResource2";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsUpdateInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365ReportingExtensionsUpdate";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedVersion = Get-Dynamics365ReportingExtensionsVersion;
} else {
    $installedVersion = Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Get-Dynamics365ReportingExtensionsVersion;
    }
}
if ( $installedVersion ) {
    if ( $installedVersion.ToString(3) -ne $updatedVersion2 ) {
        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
    Exit 1;
}

# Testing idempotence
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
    Save-Dynamics365Resource -Resource $serverUpdateResource -TargetDirectory C:\Install\Dynamics\$serverUpdateResource
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$serverUpdateResource ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$serverUpdateResource, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource $serverUpdateResource2 -TargetDirectory C:\Install\Dynamics\$serverUpdateResource2
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$serverUpdateResource2 ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$serverUpdateResource2, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource Dynamics365Server91LanguagePackUpdate01Sve -TargetDirectory C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\Dynamics365Server91LanguagePackUpdate01Sve, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource $reportingExtensionsUpdateResource -TargetDirectory C:\Install\Dynamics\$reportingExtensionsUpdateResource
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$reportingExtensionsUpdateResource ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$reportingExtensionsUpdateResource, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource $reportingExtensionsUpdateResource2 -TargetDirectory C:\Install\Dynamics\$reportingExtensionsUpdateResource2
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\$reportingExtensionsUpdateResource2 ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\$reportingExtensionsUpdateResource2, test is not OK";
    Exit 1;
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME.$domainName with dbHostName=$dbHostName parameter";
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $dbHostName, $serverUpdateResource )
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
            -CreateDatabase `
            -ServerRoles BackEnd, DeploymentAdministration `
            -SqlServer $dbHostName\SQLInstance01 `
            -Patch C:\Install\Dynamics\$serverUpdateResource `
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
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $dbHostName, $serverUpdateResource;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $serverUpdateResource2 )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\$serverUpdateResource2 `
            -LogFilePath c:\tmp\Dynamics365ServerUpdateInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $serverUpdateResource2
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}

try {
    Install-Dynamics365Language -MediaDir C:\Install\Dynamics\Dynamics365Server90LanguagePackSve;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector";
        $patchPath = "C:\Install\Dynamics\$reportingExtensionsUpdateResource";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90RTMEnu\SrsDataConnector";
        $patchPath = "\\$env:COMPUTERNAME\c$\Install\Dynamics\$reportingExtensionsUpdateResource";
    }
    Write-Host "Invoking command on $dbHostName.$domainName";
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir, $patchPath )
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime;
        Install-Dynamics365ReportingExtensions `
            -MediaDir $mediaDir `
            -ConfigDBServer $env:COMPUTERNAME\SQLInstance01 `
            -AutoGroupManagementOff `
            -InstanceName SSRS `
            -Patch $patchPath `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir, $patchPath;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\$reportingExtensionsUpdateResource2";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\$reportingExtensionsUpdateResource2";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsUpdateInstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365ReportingExtensionsUpdate";
    Write-Host $_.Exception.Message -ForegroundColor Red;
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
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
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
