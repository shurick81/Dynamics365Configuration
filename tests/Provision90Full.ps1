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

function Test-InstallDynamics365Update {
    param (
        $ResourceName
    )
    Get-PSDrive C;
    try {
        Invoke-Command "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
            param (
                $ResourceName
            )
            Import-Module c:/test-projects/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1;
            Install-Dynamics365Update -MediaDir C:\Install\Dynamics\$ResourceName `
                -LogFilePath c:\tmp\$ResourceName-InstallLog.txt `
                -LogFilePullIntervalInSeconds 15 `
                -LogFilePullToOutput
            Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
            Write-Host "(Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes";
            Write-Host (Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes;
        } -ArgumentList $ResourceName
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
        }
    }
    $attemptsLeft = 10;
    do {
        $testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP;
        if ( !$testResponse ) {
            $attemptsLeft--;
            Write-Host "Could not run test, attempts left: $attemptsLeft";
        }
    } while ( !$testResponse -and $attemptsLeft -gt 0 )
    if ( $testResponse ) {
        if ( [version]$testResponse -eq [version]$Dynamics365Resources.$ResourceName.mediaFileVersion )
        {
            Write-Host "Test OK";
        } else {
            Write-Host "Software installed version is '$testResponse'. Test is not OK";
            Exit 1;
        }
    } else {
        Write-Host "Version is not determined";
        Exit 1;
    }    
}

function Test-InstallDynamics365LanguageUpdate {
    param (
        $ResourceName
    )
    try {
        Install-Dynamics365LanguageUpdate -MediaDir C:\Install\Dynamics\$ResourceName
    } catch {
        Write-Host $_.Exception.Message -ForegroundColor Red;
        Exit 1;
    }
    $currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{0C524DC1-1419-0090-8121-88490F4D5549}" }
    Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
    if ( $currentProductInstalled ) {
        if ( [version]$currentProductInstalled.DisplayVersion -eq [version]$Dynamics365Resources.$ResourceName.mediaFileVersion ) {
            Write-Host "Test OK";
        } else {
            Write-Host "Expected update is not installed, test is not OK";
            Exit 1;
        }
    } else {
        Write-Host "Version is not determined";
        Exit 1;
    }
}

function Test-InstallDynamics365ReportingExtensionsUpdate {
    param (
        $ResourceName
    )
    try {
        if ( $dbHostName -eq $env:COMPUTERNAME ) {
            $mediaDir = "C:\Install\Dynamics\$ResourceName";
        } else {
            $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\$ResourceName";
        }
        Write-Output "dbHostName is $dbHostName"
        Invoke-Command "$dbHostName.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP {
            param( $mediaDir )
            Import-Module C:\test-projects\Dynamics365Configuration\src\Dynamics365Configuration\Dynamics365Configuration.psd1
            Write-Output "mediaDir is $mediaDir"
            Install-Dynamics365ReportingExtensionsUpdate -MediaDir $mediaDir `
                -LogFilePath c:\tmp\$ResourceName-InstallLog.txt `
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
        if ( $installedVersion -ne [version]$Dynamics365Resources.$ResourceName.mediaFileVersion ) {
            Write-Host "Incorrect version is installed: $($installedVersion.ToString())";
            Exit 1;
        }
    } else {
        Write-Host "Version is not determined";
        Exit 1;
    }
}

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
        "Dynamics365Server90ReportingExtensionsUpdate09Enu",
        "Dynamics365Server90Update10Enu",
        "Dynamics365Server90ReportingExtensionsUpdate10Enu",
        "Dynamics365Server90Update11Enu",
        "Dynamics365Server90ReportingExtensionsUpdate11Enu",
        "Dynamics365Server90Update12Enu",
        "Dynamics365Server90ReportingExtensionsUpdate12Enu",
        "Dynamics365Server90Update13Enu",
        "Dynamics365Server90ReportingExtensionsUpdate13Enu",
        "Dynamics365Server90Update14Enu",
        "Dynamics365Server90ReportingExtensionsUpdate14Enu",
        "Dynamics365Server90Update15Enu",
        "Dynamics365Server90ReportingExtensionsUpdate15Enu",
        "Dynamics365Server90Update16Enu",
        "Dynamics365Server90ReportingExtensionsUpdate16Enu",
        "Dynamics365Server90Update17Enu",
        "Dynamics365Server90ReportingExtensionsUpdate17Enu",
        "Dynamics365Server90Update18Enu",
        "Dynamics365Server90ReportingExtensionsUpdate18Enu",
        "Dynamics365Server90Update19Enu",
        "Dynamics365Server90ReportingExtensionsUpdate19Enu",
        "Dynamics365Server90Update20Enu",
        "Dynamics365Server90ReportingExtensionsUpdate20Enu",
        "Dynamics365Server90Update21Enu",
        "Dynamics365Server90ReportingExtensionsUpdate21Enu",
        "Dynamics365Server90Update22Enu",
        "Dynamics365Server90ReportingExtensionsUpdate22Enu",
        "Dynamics365Server90Update23Enu",
        "Dynamics365Server90ReportingExtensionsUpdate23Enu",
        "Dynamics365Server90Update24Enu",
        "Dynamics365Server90ReportingExtensionsUpdate24Enu",
        "Dynamics365Server90Update25Enu",
        "Dynamics365Server90ReportingExtensionsUpdate25Enu",
        "Dynamics365Server90Update26Enu",
        "Dynamics365Server90ReportingExtensionsUpdate26Enu",
        "Dynamics365Server90Update27Enu",
        "Dynamics365Server90ReportingExtensionsUpdate27Enu",
        "Dynamics365Server90Update28Enu",
        "Dynamics365Server90ReportingExtensionsUpdate28Enu",
        "Dynamics365Server90Update30Enu",
        "Dynamics365Server90ReportingExtensionsUpdate30Enu",
        "Dynamics365Server90Update31Enu",
        "Dynamics365Server90ReportingExtensionsUpdate31Enu",
        "Dynamics365Server90Update32Enu",
        "Dynamics365Server90ReportingExtensionsUpdate32Enu",
        "Dynamics365Server90Update33Enu",
        "Dynamics365Server90ReportingExtensionsUpdate33Enu",
        "Dynamics365Server90Update34Enu",
        "Dynamics365Server90ReportingExtensionsUpdate34Enu",
        "Dynamics365Server90Update35Enu",
        "Dynamics365Server90ReportingExtensionsUpdate35Enu",
        "Dynamics365Server90Update37Enu",
        "Dynamics365Server90ReportingExtensionsUpdate37Enu",
        "Dynamics365Server90Update38Enu",
        "Dynamics365Server90ReportingExtensionsUpdate38Enu",
        "Dynamics365Server90Update40Enu",
        "Dynamics365Server90ReportingExtensionsUpdate40Enu",
        "Dynamics365Server90Update42Enu",
        "Dynamics365Server90ReportingExtensionsUpdate42Enu",
        "Dynamics365Server90Update43Enu",
        "Dynamics365Server90ReportingExtensionsUpdate43Enu",
        "Dynamics365Server90Update44Enu",
        "Dynamics365Server90ReportingExtensionsUpdate44Enu",
        "Dynamics365Server91Update01Enu",
        "Dynamics365Server91LanguagePackUpdate01Rus",
        "Dynamics365Server91ReportingExtensionsUpdate01Enu",
        "Dynamics365Server91Update02Enu",
        "Dynamics365Server91ReportingExtensionsUpdate02Enu",
        "Dynamics365Server91Update03Enu",
        "Dynamics365Server91ReportingExtensionsUpdate03Enu",
        "Dynamics365Server91Update04Enu",
        "Dynamics365Server91ReportingExtensionsUpdate04Enu",
        "Dynamics365Server91Update05Enu",
        "Dynamics365Server91ReportingExtensionsUpdate05Enu",
        "Dynamics365Server91Update06Enu",
        "Dynamics365Server91ReportingExtensionsUpdate06Enu",
        "Dynamics365Server91Update07Enu",
        "Dynamics365Server91ReportingExtensionsUpdate07Enu",
        "Dynamics365Server91Update09Enu",
        "Dynamics365Server91ReportingExtensionsUpdate09Enu",
        "Dynamics365Server91Update10Enu",
        "Dynamics365Server91ReportingExtensionsUpdate10Enu",
        "Dynamics365Server91Update11Enu",
        "Dynamics365Server91ReportingExtensionsUpdate11Enu",
        "Dynamics365Server91Update12Enu",
        "Dynamics365Server91ReportingExtensionsUpdate12Enu",
        "Dynamics365Server91Update13Enu",
        "Dynamics365Server91ReportingExtensionsUpdate13Enu",
        "Dynamics365Server91Update14Enu",
        "Dynamics365Server91ReportingExtensionsUpdate14Enu",
        "Dynamics365Server91Update15Enu",
        "Dynamics365Server91ReportingExtensionsUpdate15Enu"
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
    "Dynamics365Server90ReportingExtensionsUpdate09Enu",
    "Dynamics365Server90Update10Enu",
    "Dynamics365Server90ReportingExtensionsUpdate10Enu",
    "Dynamics365Server90Update11Enu",
    "Dynamics365Server90ReportingExtensionsUpdate11Enu",
    "Dynamics365Server90Update12Enu",
    "Dynamics365Server90ReportingExtensionsUpdate12Enu",
    "Dynamics365Server90Update13Enu",
    "Dynamics365Server90ReportingExtensionsUpdate13Enu",
    "Dynamics365Server90Update14Enu",
    "Dynamics365Server90ReportingExtensionsUpdate14Enu",
    "Dynamics365Server90Update15Enu",
    "Dynamics365Server90ReportingExtensionsUpdate15Enu",
    "Dynamics365Server90Update16Enu",
    "Dynamics365Server90ReportingExtensionsUpdate16Enu",
    "Dynamics365Server90Update17Enu",
    "Dynamics365Server90ReportingExtensionsUpdate17Enu",
    "Dynamics365Server90Update18Enu",
    "Dynamics365Server90ReportingExtensionsUpdate18Enu",
    "Dynamics365Server90Update19Enu",
    "Dynamics365Server90ReportingExtensionsUpdate19Enu",
    "Dynamics365Server90Update20Enu",
    "Dynamics365Server90ReportingExtensionsUpdate20Enu",
    "Dynamics365Server90Update21Enu",
    "Dynamics365Server90ReportingExtensionsUpdate21Enu",
    "Dynamics365Server90Update22Enu",
    "Dynamics365Server90ReportingExtensionsUpdate22Enu",
    "Dynamics365Server90Update23Enu",
    "Dynamics365Server90ReportingExtensionsUpdate23Enu",
    "Dynamics365Server90Update24Enu",
    "Dynamics365Server90ReportingExtensionsUpdate24Enu",
    "Dynamics365Server90Update25Enu",
    "Dynamics365Server90ReportingExtensionsUpdate25Enu",
    "Dynamics365Server90Update26Enu",
    "Dynamics365Server90ReportingExtensionsUpdate26Enu",
    "Dynamics365Server90Update27Enu",
    "Dynamics365Server90ReportingExtensionsUpdate27Enu",
    "Dynamics365Server90Update28Enu",
    "Dynamics365Server90ReportingExtensionsUpdate28Enu",
    "Dynamics365Server90Update30Enu",
    "Dynamics365Server90ReportingExtensionsUpdate30Enu",
    "Dynamics365Server90Update31Enu",
    "Dynamics365Server90ReportingExtensionsUpdate31Enu",
    "Dynamics365Server90Update32Enu",
    "Dynamics365Server90ReportingExtensionsUpdate32Enu",
    "Dynamics365Server90Update33Enu",
    "Dynamics365Server90ReportingExtensionsUpdate33Enu",
    "Dynamics365Server90Update34Enu",
    "Dynamics365Server90ReportingExtensionsUpdate34Enu",
    "Dynamics365Server90Update35Enu",
    "Dynamics365Server90ReportingExtensionsUpdate35Enu",
    "Dynamics365Server90Update37Enu",
    "Dynamics365Server90ReportingExtensionsUpdate37Enu",
    "Dynamics365Server90Update38Enu",
    "Dynamics365Server90ReportingExtensionsUpdate38Enu",
    "Dynamics365Server90Update40Enu",
    "Dynamics365Server90ReportingExtensionsUpdate40Enu",
    "Dynamics365Server90Update42Enu",
    "Dynamics365Server90ReportingExtensionsUpdate42Enu",
    "Dynamics365Server90Update43Enu",
    "Dynamics365Server90ReportingExtensionsUpdate43Enu",
    "Dynamics365Server90Update44Enu",
    "Dynamics365Server90ReportingExtensionsUpdate44Enu",
"Dynamics365Server91Update01Enu",
    "Dynamics365Server91LanguagePackUpdate01Rus",
    "Dynamics365Server91ReportingExtensionsUpdate01Enu",
    "Dynamics365Server91Update02Enu",
    "Dynamics365Server91ReportingExtensionsUpdate02Enu",
    "Dynamics365Server91Update03Enu",
    "Dynamics365Server91ReportingExtensionsUpdate03Enu",
    "Dynamics365Server91Update04Enu",
    "Dynamics365Server91ReportingExtensionsUpdate04Enu",
    "Dynamics365Server91Update05Enu",
    "Dynamics365Server91ReportingExtensionsUpdate05Enu",
    "Dynamics365Server91Update06Enu",
    "Dynamics365Server91ReportingExtensionsUpdate06Enu",
    "Dynamics365Server91Update07Enu",
    "Dynamics365Server91ReportingExtensionsUpdate07Enu",
    "Dynamics365Server91Update09Enu",
    "Dynamics365Server91ReportingExtensionsUpdate09Enu",
    "Dynamics365Server91Update10Enu",
    "Dynamics365Server91ReportingExtensionsUpdate10Enu",
    "Dynamics365Server91Update11Enu",
    "Dynamics365Server91ReportingExtensionsUpdate11Enu",
    "Dynamics365Server91Update12Enu",
    "Dynamics365Server91ReportingExtensionsUpdate12Enu",
    "Dynamics365Server91Update13Enu",
    "Dynamics365Server91ReportingExtensionsUpdate13Enu",
    "Dynamics365Server91Update14Enu",
    "Dynamics365Server91ReportingExtensionsUpdate14Enu",
    "Dynamics365Server91Update15Enu",
    "Dynamics365Server91ReportingExtensionsUpdate15Enu"
) | % {
    if ( Get-ChildItem C:\Install\Dynamics\$_ ) {
        Write-Host "Test OK";
    } else {
        Write-Host "Expected files are not found in C:\Install\Dynamics\$_, test is not OK";
        Exit 1;
    }
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
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMEnu `
            -CreateDatabase `
            -SqlServer $dbHostName\SQLInstance01 `
            -PrivUserGroup "CN=CRM01PrivUserGroup02,OU=CRM groups 02,DC=contoso,DC=local" `
            -SQLAccessGroup "CN=CRM01SQLAccessGroup02,OU=CRM groups 02,DC=contoso,DC=local" `
            -UserGroup "CN=CRM01UserGroup02,OU=CRM groups 02,DC=contoso,DC=local" `
            -ReportingGroup "CN=CRM01ReportingGroup02,OU=CRM groups 02,DC=contoso,DC=local" `
            -PrivReportingGroup "CN=CRM01PrivReportingGroup02,OU=CRM groups 02,DC=contoso,DC=local" `
            -CrmServiceAccount $CRMServiceAccountCredential `
            -DeploymentServiceAccount $DeploymentServiceAccountCredential `
            -SandboxServiceAccount $SandboxServiceAccountCredential `
            -VSSWriterServiceAccount $VSSWriterServiceAccountCredential `
            -AsyncServiceAccount $AsyncServiceAccountCredential `
            -MonitoringServiceAccount $MonitoringServiceAccountCredential `
            -CreateWebSite `
            -WebSitePort 5555 `
            -WebSiteUrl https://$env:COMPUTERNAME.$domainName `
            -Organization "Contoso Ltd." `
            -OrganizationUniqueName Contoso `
            -BaseISOCurrencyCode USD `
            -BaseCurrencyName "US Dollar" `
            -BaseCurrencySymbol `$ `
            -BaseCurrencyPrecision 2 `
            -OrganizationCollation Latin1_General_CI_AI `
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
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $testResponse ) {
    if ( [version]$testResponse.ToString(3) -eq "9.0.2" )
    {
        Write-Host "Test OK";
    } else {
        Write-Host "Software installed version is '$testResponse'. Test is not OK";
        Exit 1;
    }
} else {
    Write-Host "Version is not determined";
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

Test-InstallDynamics365Update Dynamics365Server90Update03Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate03Enu;
Test-InstallDynamics365Update Dynamics365Server90Update04Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate04Enu;
Test-InstallDynamics365Update Dynamics365Server90Update05Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate05Enu;
Test-InstallDynamics365Update Dynamics365Server90Update06Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate06Enu;
Test-InstallDynamics365Update Dynamics365Server90Update07Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate07Enu;
Test-InstallDynamics365Update Dynamics365Server90Update08Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate08Enu;
Test-InstallDynamics365Update Dynamics365Server90Update09Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate09Enu;
Test-InstallDynamics365Update Dynamics365Server90Update10Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate10Enu;
Test-InstallDynamics365Update Dynamics365Server90Update11Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate11Enu;
Test-InstallDynamics365Update Dynamics365Server90Update12Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate12Enu;
Test-InstallDynamics365Update Dynamics365Server90Update13Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate13Enu;
Test-InstallDynamics365Update Dynamics365Server90Update14Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate14Enu;
Test-InstallDynamics365Update Dynamics365Server90Update15Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate15Enu;
Test-InstallDynamics365Update Dynamics365Server90Update16Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate16Enu;
Test-InstallDynamics365Update Dynamics365Server90Update17Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate17Enu;
Test-InstallDynamics365Update Dynamics365Server90Update18Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate18Enu;
Test-InstallDynamics365Update Dynamics365Server90Update19Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate19Enu;
Test-InstallDynamics365Update Dynamics365Server90Update20Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate20Enu;
Test-InstallDynamics365Update Dynamics365Server90Update21Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate21Enu;
Test-InstallDynamics365Update Dynamics365Server90Update22Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate22Enu;
Test-InstallDynamics365Update Dynamics365Server90Update23Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate23Enu;
Test-InstallDynamics365Update Dynamics365Server90Update24Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate24Enu;
Test-InstallDynamics365Update Dynamics365Server90Update25Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate25Enu;
Test-InstallDynamics365Update Dynamics365Server90Update26Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate26Enu;
Test-InstallDynamics365Update Dynamics365Server90Update27Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate27Enu;
Test-InstallDynamics365Update Dynamics365Server90Update28Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate28Enu;
Test-InstallDynamics365Update Dynamics365Server90Update30Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate30Enu;
Test-InstallDynamics365Update Dynamics365Server90Update31Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate31Enu;
Test-InstallDynamics365Update Dynamics365Server90Update32Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate32Enu;
Test-InstallDynamics365Update Dynamics365Server90Update33Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate33Enu;
Test-InstallDynamics365Update Dynamics365Server90Update34Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate34Enu;
Test-InstallDynamics365Update Dynamics365Server90Update35Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate35Enu;
Test-InstallDynamics365Update Dynamics365Server90Update37Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate37Enu;
Test-InstallDynamics365Update Dynamics365Server90Update38Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate38Enu;
Test-InstallDynamics365Update Dynamics365Server90Update40Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate40Enu;
Test-InstallDynamics365Update Dynamics365Server90Update42Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate42Enu;
Test-InstallDynamics365Update Dynamics365Server90Update43Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate43Enu;
Test-InstallDynamics365Update Dynamics365Server90Update44Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server90ReportingExtensionsUpdate44Enu;
Test-InstallDynamics365Update Dynamics365Server91Update01Enu;
Test-InstallDynamics365LanguageUpdate Dynamics365Server91LanguagePackUpdate01Rus;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate01Enu;
Test-InstallDynamics365Update Dynamics365Server91Update02Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate02Enu;
Test-InstallDynamics365Update Dynamics365Server91Update03Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate03Enu;
Test-InstallDynamics365Update Dynamics365Server91Update04Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate04Enu;
Test-InstallDynamics365Update Dynamics365Server91Update05Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate05Enu;
Test-InstallDynamics365Update Dynamics365Server91Update06Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate06Enu;
Test-InstallDynamics365Update Dynamics365Server91Update07Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate07Enu;
Test-InstallDynamics365Update Dynamics365Server91Update09Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate09Enu;
Test-InstallDynamics365Update Dynamics365Server91Update10Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate10Enu;
Test-InstallDynamics365Update Dynamics365Server91Update11Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate11Enu;
Test-InstallDynamics365Update Dynamics365Server91Update12Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate12Enu;
Test-InstallDynamics365Update Dynamics365Server91Update13Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate13Enu;
Test-InstallDynamics365Update Dynamics365Server91Update14Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate14Enu;
Test-InstallDynamics365Update Dynamics365Server91Update15Enu;
Test-InstallDynamics365ReportingExtensionsUpdate Dynamics365Server91ReportingExtensionsUpdate15Enu;

Exit 0;
