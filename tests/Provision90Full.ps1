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
    @(
        "Dynamics365Server90RTMEnu",
        #"Dynamics365Server90LanguagePackEnu",
        "Dynamics365Server90LanguagePackSau",
        "Dynamics365Server90LanguagePackEus",
        "Dynamics365Server90LanguagePackBgr",
        "Dynamics365Server90LanguagePackCat",
        "Dynamics365Server90LanguagePackChk",
        "Dynamics365Server90LanguagePackChs",
        "Dynamics365Server90LanguagePackCht",
        "Dynamics365Server90LanguagePackHrv",
        "Dynamics365Server90LanguagePackCsy",
        "Dynamics365Server90LanguagePackDan",
        "Dynamics365Server90LanguagePackNld",
        "Dynamics365Server90LanguagePackEti",
        "Dynamics365Server90LanguagePackFin",
        "Dynamics365Server90LanguagePackFra",
        "Dynamics365Server90LanguagePackGlc",
        "Dynamics365Server90LanguagePackDeu",
        "Dynamics365Server90LanguagePackEll",
        "Dynamics365Server90LanguagePackHeb",
        "Dynamics365Server90LanguagePackHin",
        "Dynamics365Server90LanguagePackHun",
        "Dynamics365Server90LanguagePackInd",
        "Dynamics365Server90LanguagePackIta",
        "Dynamics365Server90LanguagePackJpn",
        "Dynamics365Server90LanguagePackKkz",
        "Dynamics365Server90LanguagePackKor",
        "Dynamics365Server90LanguagePackLvi",
        "Dynamics365Server90LanguagePackLth",
        "Dynamics365Server90LanguagePackMsl",
        "Dynamics365Server90LanguagePackNor",
        "Dynamics365Server90LanguagePackPlk",
        "Dynamics365Server90LanguagePackPtb",
        "Dynamics365Server90LanguagePackPtg",
        "Dynamics365Server90LanguagePackRom",
        "Dynamics365Server90LanguagePackRus",
        "Dynamics365Server90LanguagePackSrb",
        "Dynamics365Server90LanguagePackSrl",
        "Dynamics365Server90LanguagePackSky",
        "Dynamics365Server90LanguagePackSlv",
        "Dynamics365Server90LanguagePackEsn",
        "Dynamics365Server90LanguagePackSve",
        "Dynamics365Server90LanguagePackTha",
        "Dynamics365Server90LanguagePackTrk",
        "Dynamics365Server90LanguagePackUkr",
        "Dynamics365Server90LanguagePackVit",
        "Dynamics365Server90Update03Enu",
        "Dynamics365Server90ReportingExtensionsUpdate03Enu",
        "Dynamics365Server90Update04Enu",
        "Dynamics365Server90ReportingExtensionsUpdate04Enu",
        "Dynamics365Server90Update05Enu",
        "Dynamics365Server90ReportingExtensionsUpdate05Enu",
        "Dynamics365Server90Update06Enu",
        "Dynamics365Server90ReportingExtensionsUpdate06Enu",
        "Dynamics365Server90Update07Enu",
        "Dynamics365Server90ReportingExtensionsUpdate07Enu",
        "Dynamics365Server90Update08Enu",
        "Dynamics365Server90ReportingExtensionsUpdate08Enu",
        "Dynamics365Server90Update09Enu",
        "Dynamics365Server90ReportingExtensionsUpdate09Enu"
    ) | % { Save-Dynamics365Resource -Resource $_ -TargetDirectory C:\Install\Dynamics\$_ }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
@(
    "Dynamics365Server90RTMEnu",
   #"Dynamics365Server90LanguagePackEnu",
    "Dynamics365Server90LanguagePackSau",
    "Dynamics365Server90LanguagePackEus",
    "Dynamics365Server90LanguagePackBgr",
    "Dynamics365Server90LanguagePackCat",
    "Dynamics365Server90LanguagePackChk",
    "Dynamics365Server90LanguagePackChs",
    "Dynamics365Server90LanguagePackCht",
    "Dynamics365Server90LanguagePackHrv",
    "Dynamics365Server90LanguagePackCsy",
    "Dynamics365Server90LanguagePackDan",
    "Dynamics365Server90LanguagePackNld",
    "Dynamics365Server90LanguagePackEti",
    "Dynamics365Server90LanguagePackFin",
    "Dynamics365Server90LanguagePackFra",
    "Dynamics365Server90LanguagePackGlc",
    "Dynamics365Server90LanguagePackDeu",
    "Dynamics365Server90LanguagePackEll",
    "Dynamics365Server90LanguagePackHeb",
    "Dynamics365Server90LanguagePackHin",
    "Dynamics365Server90LanguagePackHun",
    "Dynamics365Server90LanguagePackInd",
    "Dynamics365Server90LanguagePackIta",
    "Dynamics365Server90LanguagePackJpn",
    "Dynamics365Server90LanguagePackKkz",
    "Dynamics365Server90LanguagePackKor",
    "Dynamics365Server90LanguagePackLvi",
    "Dynamics365Server90LanguagePackLth",
    "Dynamics365Server90LanguagePackMsl",
    "Dynamics365Server90LanguagePackNor",
    "Dynamics365Server90LanguagePackPlk",
    "Dynamics365Server90LanguagePackPtb",
    "Dynamics365Server90LanguagePackPtg",
    "Dynamics365Server90LanguagePackRom",
    "Dynamics365Server90LanguagePackRus",
    "Dynamics365Server90LanguagePackSrb",
    "Dynamics365Server90LanguagePackSrl",
    "Dynamics365Server90LanguagePackSky",
    "Dynamics365Server90LanguagePackSlv",
    "Dynamics365Server90LanguagePackEsn",
    "Dynamics365Server90LanguagePackSve",
    "Dynamics365Server90LanguagePackTha",
    "Dynamics365Server90LanguagePackTrk",
    "Dynamics365Server90LanguagePackUkr",
    "Dynamics365Server90LanguagePackVit",
    "Dynamics365Server90Update03Enu",
    "Dynamics365Server90ReportingExtensionsUpdate03Enu",
    "Dynamics365Server90Update04Enu",
    "Dynamics365Server90ReportingExtensionsUpdate04Enu",
    "Dynamics365Server90Update05Enu",
    "Dynamics365Server90ReportingExtensionsUpdate05Enu",
    "Dynamics365Server90Update06Enu",
    "Dynamics365Server90ReportingExtensionsUpdate06Enu",
    "Dynamics365Server90Update07Enu",
    "Dynamics365Server90ReportingExtensionsUpdate07Enu",
    "Dynamics365Server90Update08Enu",
    "Dynamics365Server90ReportingExtensionsUpdate08Enu",
    "Dynamics365Server90Update09Enu",
    "Dynamics365Server90ReportingExtensionsUpdate09Enu"
) | % {
    if ( Get-ChildItem C:\Install\Dynamics\$_ ) {
        Write-Host "Test OK";
    } else {
        Write-Host "Expected files are not found in C:\Install\Dynamics\$_, test is not OK";
        Exit 1;
    }
}

try {
    Write-Host "Invoking command on $env:COMPUTERNAME with dbHostName=$dbHostName parameter";
    Invoke-Command "$env:COMPUTERNAME.contoso.local" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
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
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
            -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
            -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
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
            -BaseISOCurrencyCode USD `
            -BaseCurrencyName "US Dollar" `
            -BaseCurrencySymbol `$ `
            -BaseCurrencyPrecision 2 `
            -OrganizationCollation Latin1_General_CI_AI `
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
    @(
       #"Dynamics365Server90LanguagePackEnu",
        "Dynamics365Server90LanguagePackSau",
        "Dynamics365Server90LanguagePackEus",
        "Dynamics365Server90LanguagePackBgr",
        "Dynamics365Server90LanguagePackCat",
        "Dynamics365Server90LanguagePackChk",
        "Dynamics365Server90LanguagePackChs",
        "Dynamics365Server90LanguagePackCht",
        "Dynamics365Server90LanguagePackHrv",
        "Dynamics365Server90LanguagePackCsy",
        "Dynamics365Server90LanguagePackDan",
        "Dynamics365Server90LanguagePackNld",
        "Dynamics365Server90LanguagePackEti",
        "Dynamics365Server90LanguagePackFin",
        "Dynamics365Server90LanguagePackFra",
        "Dynamics365Server90LanguagePackGlc",
        "Dynamics365Server90LanguagePackDeu",
        "Dynamics365Server90LanguagePackEll",
        "Dynamics365Server90LanguagePackHeb",
        "Dynamics365Server90LanguagePackHin",
        "Dynamics365Server90LanguagePackHun",
        "Dynamics365Server90LanguagePackInd",
        "Dynamics365Server90LanguagePackIta",
        "Dynamics365Server90LanguagePackJpn",
        "Dynamics365Server90LanguagePackKkz",
        "Dynamics365Server90LanguagePackKor",
        "Dynamics365Server90LanguagePackLvi",
        "Dynamics365Server90LanguagePackLth",
        "Dynamics365Server90LanguagePackMsl",
        "Dynamics365Server90LanguagePackNor",
        "Dynamics365Server90LanguagePackPlk",
        "Dynamics365Server90LanguagePackPtb",
        "Dynamics365Server90LanguagePackPtg",
        "Dynamics365Server90LanguagePackRom",
        "Dynamics365Server90LanguagePackRus",
        "Dynamics365Server90LanguagePackSrb",
        "Dynamics365Server90LanguagePackSrl",
        "Dynamics365Server90LanguagePackSky",
        "Dynamics365Server90LanguagePackSlv",
        "Dynamics365Server90LanguagePackEsn",
        "Dynamics365Server90LanguagePackSve",
        "Dynamics365Server90LanguagePackTha",
        "Dynamics365Server90LanguagePackTrk",
        "Dynamics365Server90LanguagePackUkr",
        "Dynamics365Server90LanguagePackVit"
    ) | % { Install-Dynamics365Language -MediaDir C:\Install\Dynamics\$_ }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProducts = Get-WmiObject Win32_Product | % { $_.IdentifyingNumber }
@(
    #"0C524DC1-1409-0090-8121-88490F4D5549",
    "0C524DC1-1402-0090-8121-88490F4D5549",
    "0C524DC1-1403-0090-8121-88490F4D5549",
    "0C524DC1-1C04-0090-8121-88490F4D5549",
    "0C524DC1-1804-0090-8121-88490F4D5549",
    "0C524DC1-1404-0090-8121-88490F4D5549",
    "0C524DC1-1405-0090-8121-88490F4D5549",
    "0C524DC1-1406-0090-8121-88490F4D5549",
    "0C524DC1-1407-0090-8121-88490F4D5549",
    "0C524DC1-1408-0090-8121-88490F4D5549",
    "0C524DC1-1C0A-0090-8121-88490F4D5549",
    "0C524DC1-1425-0090-8121-88490F4D5549",
    "0C524DC1-142D-0090-8121-88490F4D5549",
    "0C524DC1-140B-0090-8121-88490F4D5549",
    "0C524DC1-140C-0090-8121-88490F4D5549",
    "0C524DC1-1456-0090-8121-88490F4D5549",
    "0C524DC1-140D-0090-8121-88490F4D5549",
    "0C524DC1-1439-0090-8121-88490F4D5549",
    "0C524DC1-141A-0090-8121-88490F4D5549",
    "0C524DC1-140E-0090-8121-88490F4D5549",
    "0C524DC1-1421-0090-8121-88490F4D5549",
    "0C524DC1-1410-0090-8121-88490F4D5549",
    "0C524DC1-1411-0090-8121-88490F4D5549",
    "0C524DC1-143F-0090-8121-88490F4D5549",
    "0C524DC1-1412-0090-8121-88490F4D5549",
    "0C524DC1-1427-0090-8121-88490F4D5549",
    "0C524DC1-1426-0090-8121-88490F4D5549",
    "0C524DC1-143E-0090-8121-88490F4D5549",
    "0C524DC1-1413-0090-8121-88490F4D5549",
    "0C524DC1-1414-0090-8121-88490F4D5549",
    "0C524DC1-1415-0090-8121-88490F4D5549",
    "0C524DC1-1416-0090-8121-88490F4D5549",
    "0C524DC1-1816-0090-8121-88490F4D5549",
    "0C524DC1-1418-0090-8121-88490F4D5549",
    "0C524DC1-1419-0090-8121-88490F4D5549",
    "0C524DC1-1401-0090-8121-88490F4D5549",
    "0C524DC1-141B-0090-8121-88490F4D5549",
    "0C524DC1-1424-0090-8121-88490F4D5549",
    "0C524DC1-1C1A-0090-8121-88490F4D5549",
    "0C524DC1-181A-0090-8121-88490F4D5549",
    "0C524DC1-141D-0090-8121-88490F4D5549",
    "0C524DC1-141E-0090-8121-88490F4D5549",
    "0C524DC1-141F-0090-8121-88490F4D5549",
    "0C524DC1-1422-0090-8121-88490F4D5549",
    "0C524DC1-142A-0090-8121-88490F4D5549"
) | % {
    if ( $installedProducts -contains "{$_}" ) {
        Write "Product $_ is installed, test OK";
    } else {
        Write-Host "Expected product $_ is not installed, test is not OK";
        Exit 1;    
    }
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

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update04Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate904InstallLog.txt `
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
if ( $testResponse -eq "9.0.4.5" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate904InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate904InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate904InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate04Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate04Enu";
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
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0004.0005" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update05Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate905InstallLog.txt `
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
if ( $testResponse -eq "9.0.5.5" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate905InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate905InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate905InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate05Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate05Enu";
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
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0005.0005" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update06Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate906InstallLog.txt `
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
if ( $testResponse -eq "9.0.6.9" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate906InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate906InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate906InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate06Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate06Enu";
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
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0006.0009" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update07Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate907InstallLog.txt `
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
if ( $testResponse -eq "9.0.7.7" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate907InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate907InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate907InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate07Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate07Enu";
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
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0007.0007" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update08Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate908InstallLog.txt `
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
if ( $testResponse -eq "9.0.8.5" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate908InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate908InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate908InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate08Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate08Enu";
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
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0008.0005" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

try {
    Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
        Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
        Install-Dynamics365Update -MediaDir C:\Install\Dynamics\Dynamics365Server90Update09Enu `
            -LogFilePath c:\tmp\Dynamics365ServerUpdate909InstallLog.txt `
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
if ( $testResponse -eq "9.0.9.4" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}
if( Test-Path "c:\tmp\Dynamics365ServerUpdate909InstallLog.txt" )
{
    Write-Output "File c:\tmp\Dynamics365ServerUpdate909InstallLog.txt is found, test OK"
} else {
    Write-Output "File c:\tmp\Dynamics365ServerUpdate909InstallLog.txt is not found"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        $mediaDir = "C:\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate09Enu";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90ReportingExtensionsUpdate09Enu";
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
if ( $currentProductInstalled.DisplayVersion -eq "9.0.0009.0004" ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected update is not installed, test is not OK";
    Exit 1;
}

Exit 0;
