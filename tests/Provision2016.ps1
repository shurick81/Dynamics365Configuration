$dbHostName = $env:VMDEVOPSSTARTER_DBHOST;
if ( !$dbHostName ) { $dbHostName = $env:COMPUTERNAME }
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
$domainName = (Get-WmiObject Win32_ComputerSystem).Domain;

try {
    Save-Dynamics365Resource -Resource CRM2016RTMSve -TargetDirectory C:\Install\Dynamics\CRM2016RTMSve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016RTMSve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016RTMSve, test is not OK";
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
    Save-Dynamics365Resource -Resource CRM2016ServicePack1Sve -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack1Sve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ServicePack1Sve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ServicePack1Sve, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ServicePack2Update28Sve -TargetDirectory C:\Install\Dynamics\CRM2016ServicePack2Update28Sve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ServicePack2Update28Sve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ServicePack2Update28Sve, test is not OK";
    Exit 1;
}

try {
    Save-Dynamics365Resource -Resource CRM2016ReportingExtensionsServicePack2Update28Sve -TargetDirectory C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Sve
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( Get-ChildItem C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Sve ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected files are not found in C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Sve, test is not OK";
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
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        $securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
        $CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
        $DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
        $SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
        $VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
        $AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
        $MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
        Install-Dynamics365Server `
            -MediaDir C:\Install\Dynamics\CRM2016RTMSve `
            -CreateDatabase `
            -SqlServer $dbHostName\SQLInstance01 `
            -LicenseKey WCPQN-33442-VH2RQ-M4RKF-GXYH4 `
            -OU "OU=CRM groups 01,DC=contoso,DC=local" `
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
        Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
        Write-Host "(Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes";
        Write-Host (Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes;
    } -ArgumentList $dbHostName;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Server";
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$testScriptBlock = {
    try {
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
$installedVersion = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $installedVersion ) {
    if ( $installedVersion.ToString(3) -eq "8.0.0" ) {
        Write-Host "Test OK";
    } else {
        Write-Host "Software installed version is '$installedVersion'. Test is not OK"
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerInstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerInstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerInstallLog.txt is not found"
    Exit 1;
}
$msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
if ( $msCRMRegistryValues ) {
    $installedVersion = Get-Dynamics365ServerVersion;
    if ( $installedVersion ) {
        if ( $installedVersion -ne [version]"8.0.0.1088" ) {
            Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
            Exit 1;
        }    
    } else {
        Write-Host "Version is not determined";
        Exit 1;
    }
    $installedLanguage = Get-Dynamics365ServerLanguage;
    if ( $installedLanguage -ne 1053 ) {
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
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1Sve `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate810InstallLog.txt
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
$installedVersion = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $installedVersion ) {
    if ( $installedVersion.ToString(3) -eq "8.1.0" ) {
        Write-Host "Test OK";
    } else {
        Write-Host "Software installed version is '$installedVersion'. Test is not OK"
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
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
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update28Sve `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate8228InstallLog.txt `
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
$installedVersion = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $installedVersion ) {
    if ( $installedVersion.ToString(3) -eq "8.2.28" ) {
        Write-Host "Test OK";
    } else {
        Write-Host "Software installed version is '$installedVersion'. Test is not OK"
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
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
        $mediaDir = "C:\Install\Dynamics\CRM2016RTMSve\SrsDataConnector";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016RTMSve\SrsDataConnector";
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
            -InstanceName SSRS `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsInstallLog.txt
    } -ArgumentList $mediaDir;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-141D-0080-BFEE-D90853535253}" }
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

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Sve";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016ReportingExtensionsServicePack2Update28Sve";
    }
    Write-Output "dbHostName is $dbHostName"
    Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        param( $mediaDir )
        Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
        Write-Output "mediaDir is $mediaDir"
        Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
            -LogFilePath c:\tmp\Dynamics365ServerReportingExtensionsUpdate8228InstallLog.txt `
            -LogFilePullIntervalInSeconds 15 `
            -LogFilePullToOutput
    } -ArgumentList $mediaDir;
} catch {
    Write-Host "Failed in invoking of Install-Dynamics365Update";
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
    if ( $installedVersion.ToString(3) -ne "8.2.28" ) {
        Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
    Exit 1;
}

#Write-Host "$(Get-Date) Starting New-CrmOrganization";
#$importJobId = New-CrmOrganization -Name ORGLANG1044 -BaseLanguageCode 1044 -Credential $CRMInstallAccountCredential -DwsServerUrl "http://$env:COMPUTERNAME`:5555/XrmDeployment/2011/deployment.svc" -DisplayName "Organization for testing 1044 language" -SqlServerName $dbHostName\SQLInstance01 -SrsUrl http://$dbHostName/ReportServer_SSRS;
#do {
#    $operationStatus = Get-CrmOperationStatus -OperationId $importJobId -Credential $CRMInstallAccountCredential -DwsServerUrl "http://$env:COMPUTERNAME`:5555/XrmDeployment/2011/deployment.svc";
#    Write-Host "$(Get-Date) operationStatus.State is $($operationStatus.State). Waiting until CRM installation job is done";
#    Sleep 60;
#} while ( ( $operationStatus.State -ne "Completed" ) -and ( $operationStatus.State -ne "Failed" ) )
#if ( $operationStatus.State -eq "Completed" ) {
#    Write-Host "Test OK";
#} else {
#    Write-Host "Organization was not created properly";
#    Exit 1;
#}

Exit 0;
