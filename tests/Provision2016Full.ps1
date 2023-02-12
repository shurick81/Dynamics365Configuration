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
    $currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{0C524DC1-1409-0080-8121-88490F4D5549}" }
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
        "CRM2016RTMDan",
        "CRM2016LanguagePackEnu",
        "CRM2016LanguagePackSau",
        "CRM2016LanguagePackEus",
        "CRM2016LanguagePackBgr",
        "CRM2016LanguagePackCat",
        "CRM2016LanguagePackChk",
        "CRM2016LanguagePackChs",
        "CRM2016LanguagePackCht",
        "CRM2016LanguagePackHrv",
        "CRM2016LanguagePackCsy",
        #"CRM2016LanguagePackDan",
        "CRM2016LanguagePackNld",
        "CRM2016LanguagePackEti",
        "CRM2016LanguagePackFin",
        "CRM2016LanguagePackFra",
        "CRM2016LanguagePackGlc",
        "CRM2016LanguagePackDeu",
        "CRM2016LanguagePackEll",
        "CRM2016LanguagePackHeb",
        "CRM2016LanguagePackHin",
        "CRM2016LanguagePackHun",
        "CRM2016LanguagePackInd",
        "CRM2016LanguagePackIta",
        "CRM2016LanguagePackJpn",
        "CRM2016LanguagePackKkz",
        "CRM2016LanguagePackKor",
        "CRM2016LanguagePackLvi",
        "CRM2016LanguagePackLth",
        "CRM2016LanguagePackMsl",
        "CRM2016LanguagePackNor",
        "CRM2016LanguagePackPlk",
        "CRM2016LanguagePackPtb",
        "CRM2016LanguagePackPtg",
        "CRM2016LanguagePackRom",
        "CRM2016LanguagePackRus",
        "CRM2016LanguagePackSrb",
        "CRM2016LanguagePackSrl",
        "CRM2016LanguagePackSky",
        "CRM2016LanguagePackSlv",
        "CRM2016LanguagePackEsn",
        "CRM2016LanguagePackSve",
        "CRM2016LanguagePackTha",
        "CRM2016LanguagePackTrk",
        "CRM2016LanguagePackUkr",
        "CRM2016LanguagePackVit",
        "CRM2016Update01Dan",
        "CRM2016LanguagePackUpdate01Enu",
        "CRM2016ReportingExtensionsUpdate01Dan",
        "CRM2016ServicePack1Dan",
        "CRM2016LanguagePackServicePack1Enu",
        "CRM2016ReportingExtensionsServicePack1Dan",
        "CRM2016ServicePack1Update01Dan",
        "CRM2016LanguagePackServicePack1Update01Enu",
        "CRM2016ReportingExtensionsServicePack1Update01Dan",
        "CRM2016ServicePack2Dan",
        "CRM2016LanguagePackServicePack2Enu",
        "CRM2016ReportingExtensionsServicePack2Dan",
        "CRM2016ServicePack2Update01Dan",
        "CRM2016LanguagePackServicePack2Update01Enu",
        "CRM2016ReportingExtensionsServicePack2Update01Dan",
        "CRM2016ServicePack2Update02Dan",
        "CRM2016LanguagePackServicePack2Update02Enu",
        "CRM2016ReportingExtensionsServicePack2Update02Dan",
        "CRM2016ServicePack2Update03Dan",
        "CRM2016LanguagePackServicePack2Update03Enu",
        "CRM2016ReportingExtensionsServicePack2Update03Dan",
        "CRM2016ServicePack2Update04Dan",
        "CRM2016LanguagePackServicePack2Update04Enu",
        "CRM2016ReportingExtensionsServicePack2Update04Dan",
        "CRM2016ServicePack2Update05Dan",
        "CRM2016LanguagePackServicePack2Update05Enu",
        "CRM2016ReportingExtensionsServicePack2Update05Dan",
        "CRM2016ServicePack2Update06Dan",
        "CRM2016LanguagePackServicePack2Update06Enu",
        "CRM2016ReportingExtensionsServicePack2Update06Dan",
        "CRM2016ServicePack2Update07Dan",
        "CRM2016LanguagePackServicePack2Update07Enu",
        "CRM2016ReportingExtensionsServicePack2Update07Dan",
        "CRM2016ServicePack2Update08Dan",
        "CRM2016LanguagePackServicePack2Update08Enu",
        "CRM2016ReportingExtensionsServicePack2Update08Dan",
        "CRM2016ServicePack2Update09Dan",
        "CRM2016LanguagePackServicePack2Update09Enu",
        "CRM2016ReportingExtensionsServicePack2Update09Dan",
        "CRM2016ServicePack2Update10Dan",
        "CRM2016LanguagePackServicePack2Update10Enu",
        "CRM2016ReportingExtensionsServicePack2Update10Dan",
        "CRM2016ServicePack2Update11Dan",
        "CRM2016LanguagePackServicePack2Update11Enu",
        "CRM2016ReportingExtensionsServicePack2Update11Dan",
        "CRM2016ServicePack2Update12Dan",
        "CRM2016LanguagePackServicePack2Update12Enu",
        "CRM2016ReportingExtensionsServicePack2Update12Dan",
        "CRM2016ServicePack2Update13Dan",
        "CRM2016LanguagePackServicePack2Update13Enu",
        "CRM2016ReportingExtensionsServicePack2Update13Dan",
        "CRM2016ServicePack2Update14Dan",
        "CRM2016LanguagePackServicePack2Update14Enu",
        "CRM2016ReportingExtensionsServicePack2Update14Dan",
        "CRM2016ServicePack2Update15Dan",
        "CRM2016LanguagePackServicePack2Update15Enu",
        "CRM2016ReportingExtensionsServicePack2Update15Dan",
        "CRM2016ServicePack2Update16Dan",
        "CRM2016LanguagePackServicePack2Update16Enu",
        "CRM2016ReportingExtensionsServicePack2Update16Dan",
        "CRM2016ServicePack2Update17Dan",
        "CRM2016LanguagePackServicePack2Update17Enu",
        "CRM2016ReportingExtensionsServicePack2Update17Dan",
        "CRM2016ServicePack2Update18Dan",
        "CRM2016LanguagePackServicePack2Update18Enu",
        "CRM2016ReportingExtensionsServicePack2Update18Dan",
        "CRM2016ServicePack2Update19Dan",
        "CRM2016LanguagePackServicePack2Update19Enu",
        "CRM2016ReportingExtensionsServicePack2Update19Dan",
        "CRM2016ServicePack2Update21Dan",
        "CRM2016LanguagePackServicePack2Update21Enu",
        "CRM2016ReportingExtensionsServicePack2Update21Dan",
        "CRM2016ServicePack2Update22Dan",
        "CRM2016LanguagePackServicePack2Update22Enu",
        "CRM2016ReportingExtensionsServicePack2Update22Dan",
        "CRM2016ServicePack2Update23Dan",
        "CRM2016LanguagePackServicePack2Update23Enu",
        "CRM2016ReportingExtensionsServicePack2Update23Dan",
        "CRM2016ServicePack2Update24Dan",
        "CRM2016LanguagePackServicePack2Update24Enu",
        "CRM2016ReportingExtensionsServicePack2Update24Dan",
        "CRM2016ServicePack2Update25Dan",
        "CRM2016LanguagePackServicePack2Update25Enu",
        "CRM2016ReportingExtensionsServicePack2Update25Dan",
        "CRM2016ServicePack2Update26Dan",
        "CRM2016LanguagePackServicePack2Update26Enu",
        "CRM2016ReportingExtensionsServicePack2Update26Dan",
        "CRM2016ServicePack2Update27Dan",
        "CRM2016LanguagePackServicePack2Update27Enu",
        "CRM2016ReportingExtensionsServicePack2Update27Dan",
        "CRM2016ServicePack2Update28Dan",
        "CRM2016LanguagePackServicePack2Update28Enu",
        "CRM2016ReportingExtensionsServicePack2Update28Dan"
    ) | % { Save-Dynamics365Resource -Resource $_ -TargetDirectory C:\Install\Dynamics\$_ }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
@(
    "CRM2016RTMDan",
    "CRM2016LanguagePackEnu",
    "CRM2016LanguagePackSau",
    "CRM2016LanguagePackEus",
    "CRM2016LanguagePackBgr",
    "CRM2016LanguagePackCat",
    "CRM2016LanguagePackChk",
    "CRM2016LanguagePackChs",
    "CRM2016LanguagePackCht",
    "CRM2016LanguagePackHrv",
    "CRM2016LanguagePackCsy",
    #"CRM2016LanguagePackDan",
    "CRM2016LanguagePackNld",
    "CRM2016LanguagePackEti",
    "CRM2016LanguagePackFin",
    "CRM2016LanguagePackFra",
    "CRM2016LanguagePackGlc",
    "CRM2016LanguagePackDeu",
    "CRM2016LanguagePackEll",
    "CRM2016LanguagePackHeb",
    "CRM2016LanguagePackHin",
    "CRM2016LanguagePackHun",
    "CRM2016LanguagePackInd",
    "CRM2016LanguagePackIta",
    "CRM2016LanguagePackJpn",
    "CRM2016LanguagePackKkz",
    "CRM2016LanguagePackKor",
    "CRM2016LanguagePackLvi",
    "CRM2016LanguagePackLth",
    "CRM2016LanguagePackMsl",
    "CRM2016LanguagePackNor",
    "CRM2016LanguagePackPlk",
    "CRM2016LanguagePackPtb",
    "CRM2016LanguagePackPtg",
    "CRM2016LanguagePackRom",
    "CRM2016LanguagePackRus",
    "CRM2016LanguagePackSrb",
    "CRM2016LanguagePackSrl",
    "CRM2016LanguagePackSky",
    "CRM2016LanguagePackSlv",
    "CRM2016LanguagePackEsn",
    "CRM2016LanguagePackSve",
    "CRM2016LanguagePackTha",
    "CRM2016LanguagePackTrk",
    "CRM2016LanguagePackUkr",
    "CRM2016LanguagePackVit",
    "CRM2016Update01Dan",
    "CRM2016LanguagePackUpdate01Enu",
    "CRM2016ReportingExtensionsUpdate01Dan",
    "CRM2016ServicePack1Dan",
    "CRM2016LanguagePackServicePack1Enu",
    "CRM2016ReportingExtensionsServicePack1Dan",
    "CRM2016ServicePack1Update01Dan",
    "CRM2016LanguagePackServicePack1Update01Enu",
    "CRM2016ReportingExtensionsServicePack1Update01Dan",
    "CRM2016ServicePack2Dan",
    "CRM2016LanguagePackServicePack2Enu",
    "CRM2016ReportingExtensionsServicePack2Dan",
    "CRM2016ServicePack2Update01Dan",
    "CRM2016LanguagePackServicePack2Update01Enu",
    "CRM2016ReportingExtensionsServicePack2Update01Dan",
    "CRM2016ServicePack2Update02Dan",
    "CRM2016LanguagePackServicePack2Update02Enu",
    "CRM2016ReportingExtensionsServicePack2Update02Dan",
    "CRM2016ServicePack2Update03Dan",
    "CRM2016LanguagePackServicePack2Update03Enu",
    "CRM2016ReportingExtensionsServicePack2Update03Dan",
    "CRM2016ServicePack2Update04Dan",
    "CRM2016LanguagePackServicePack2Update04Enu",
    "CRM2016ReportingExtensionsServicePack2Update04Dan",
    "CRM2016ServicePack2Update05Dan",
    "CRM2016LanguagePackServicePack2Update05Enu",
    "CRM2016ReportingExtensionsServicePack2Update05Dan",
    "CRM2016ServicePack2Update06Dan",
    "CRM2016LanguagePackServicePack2Update06Enu",
    "CRM2016ReportingExtensionsServicePack2Update06Dan",
    "CRM2016ServicePack2Update07Dan",
    "CRM2016LanguagePackServicePack2Update07Enu",
    "CRM2016ReportingExtensionsServicePack2Update07Dan",
    "CRM2016ServicePack2Update08Dan",
    "CRM2016LanguagePackServicePack2Update08Enu",
    "CRM2016ReportingExtensionsServicePack2Update08Dan",
    "CRM2016ServicePack2Update09Dan",
    "CRM2016LanguagePackServicePack2Update09Enu",
    "CRM2016ReportingExtensionsServicePack2Update09Dan",
    "CRM2016ServicePack2Update10Dan",
    "CRM2016LanguagePackServicePack2Update10Enu",
    "CRM2016ReportingExtensionsServicePack2Update10Dan",
    "CRM2016ServicePack2Update11Dan",
    "CRM2016LanguagePackServicePack2Update11Enu",
    "CRM2016ReportingExtensionsServicePack2Update11Dan",
    "CRM2016ServicePack2Update12Dan",
    "CRM2016LanguagePackServicePack2Update12Enu",
    "CRM2016ReportingExtensionsServicePack2Update12Dan",
    "CRM2016ServicePack2Update13Dan",
    "CRM2016LanguagePackServicePack2Update13Enu",
    "CRM2016ReportingExtensionsServicePack2Update13Dan",
    "CRM2016ServicePack2Update14Dan",
    "CRM2016LanguagePackServicePack2Update14Enu",
    "CRM2016ReportingExtensionsServicePack2Update14Dan",
    "CRM2016ServicePack2Update15Dan",
    "CRM2016LanguagePackServicePack2Update15Enu",
    "CRM2016ReportingExtensionsServicePack2Update15Dan",
    "CRM2016ServicePack2Update16Dan",
    "CRM2016LanguagePackServicePack2Update16Enu",
    "CRM2016ReportingExtensionsServicePack2Update16Dan",
    "CRM2016ServicePack2Update17Dan",
    "CRM2016LanguagePackServicePack2Update17Enu",
    "CRM2016ReportingExtensionsServicePack2Update17Dan",
    "CRM2016ServicePack2Update18Dan",
    "CRM2016LanguagePackServicePack2Update18Enu",
    "CRM2016ReportingExtensionsServicePack2Update18Dan",
    "CRM2016ServicePack2Update19Dan",
    "CRM2016LanguagePackServicePack2Update19Enu",
    "CRM2016ReportingExtensionsServicePack2Update19Dan",
    "CRM2016ServicePack2Update21Dan",
    "CRM2016LanguagePackServicePack2Update21Enu",
    "CRM2016ReportingExtensionsServicePack2Update21Dan",
    "CRM2016ServicePack2Update22Dan",
    "CRM2016LanguagePackServicePack2Update22Enu",
    "CRM2016ReportingExtensionsServicePack2Update22Dan",
    "CRM2016ServicePack2Update23Dan",
    "CRM2016LanguagePackServicePack2Update23Enu",
    "CRM2016ReportingExtensionsServicePack2Update23Dan",
    "CRM2016ServicePack2Update24Dan",
    "CRM2016LanguagePackServicePack2Update24Enu",
    "CRM2016ReportingExtensionsServicePack2Update24Dan",
    "CRM2016ServicePack2Update25Dan",
    "CRM2016LanguagePackServicePack2Update25Enu",
    "CRM2016ReportingExtensionsServicePack2Update25Dan",
    "CRM2016ServicePack2Update26Dan",
    "CRM2016LanguagePackServicePack2Update26Enu",
    "CRM2016ReportingExtensionsServicePack2Update26Dan",
    "CRM2016ServicePack2Update27Dan",
    "CRM2016LanguagePackServicePack2Update27Enu",
    "CRM2016ReportingExtensionsServicePack2Update27Dan",
    "CRM2016ServicePack2Update28Dan",
    "CRM2016LanguagePackServicePack2Update28Enu",
    "CRM2016ReportingExtensionsServicePack2Update28Dan"
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
            -MediaDir C:\Install\Dynamics\CRM2016RTMDan `
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
            -OrganizationCollation Danish_Norwegian_CI_AI `
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
        Write-Host "(Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes";
        Write-Host (Get-CrmAdvancedSetting -ConfigurationEntityName Deployment -Setting AutomaticallyInstallDatabaseUpdates).Attributes;
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
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock "$env:COMPUTERNAME.$domainName" -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $testResponse ) {
    if ( ([version]$testResponse).ToString(3) -eq "8.0.0" )
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
        "CRM2016LanguagePackEnu",
        "CRM2016LanguagePackSau",
        "CRM2016LanguagePackEus",
        "CRM2016LanguagePackBgr",
        "CRM2016LanguagePackCat",
        "CRM2016LanguagePackChk",
        "CRM2016LanguagePackChs",
        "CRM2016LanguagePackCht",
        "CRM2016LanguagePackHrv",
        "CRM2016LanguagePackCsy",
        #"CRM2016LanguagePackDan",
        "CRM2016LanguagePackNld",
        "CRM2016LanguagePackEti",
        "CRM2016LanguagePackFin",
        "CRM2016LanguagePackFra",
        "CRM2016LanguagePackGlc",
        "CRM2016LanguagePackDeu",
        "CRM2016LanguagePackEll",
        "CRM2016LanguagePackHeb",
        "CRM2016LanguagePackHin",
        "CRM2016LanguagePackHun",
        "CRM2016LanguagePackInd",
        "CRM2016LanguagePackIta",
        "CRM2016LanguagePackJpn",
        "CRM2016LanguagePackKkz",
        "CRM2016LanguagePackKor",
        "CRM2016LanguagePackLvi",
        "CRM2016LanguagePackLth",
        "CRM2016LanguagePackMsl",
        "CRM2016LanguagePackNor",
        "CRM2016LanguagePackPlk",
        "CRM2016LanguagePackPtb",
        "CRM2016LanguagePackPtg",
        "CRM2016LanguagePackRom",
        "CRM2016LanguagePackRus",
        "CRM2016LanguagePackSrb",
        "CRM2016LanguagePackSrl",
        "CRM2016LanguagePackSky",
        "CRM2016LanguagePackSlv",
        "CRM2016LanguagePackEsn",
        "CRM2016LanguagePackSve",
        "CRM2016LanguagePackTha",
        "CRM2016LanguagePackTrk",
        "CRM2016LanguagePackUkr",
        "CRM2016LanguagePackVit"
    ) | % { Install-Dynamics365Language -MediaDir C:\Install\Dynamics\$_ }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProducts = Get-WmiObject Win32_Product | % { $_.IdentifyingNumber }
@(
    "0C524DC1-1409-0080-8121-88490F4D5549",
    "0C524DC1-1402-0080-8121-88490F4D5549",
    "0C524DC1-1403-0080-8121-88490F4D5549",
    "0C524DC1-1C04-0080-8121-88490F4D5549",
    "0C524DC1-1804-0080-8121-88490F4D5549",
    "0C524DC1-1404-0080-8121-88490F4D5549",
    "0C524DC1-1405-0080-8121-88490F4D5549",
    "0C524DC1-1407-0080-8121-88490F4D5549",
    "0C524DC1-141A-0080-8121-88490F4D5549",
    "0C524DC1-1408-0080-8121-88490F4D5549",
    #"0C524DC1-1406-0080-8121-88490F4D5549",
    "0C524DC1-1C0A-0080-8121-88490F4D5549",
    "0C524DC1-1425-0080-8121-88490F4D5549",
    "0C524DC1-142B-0080-8121-88490F4D5549",
    "0C524DC1-140B-0080-8121-88490F4D5549",
    "0C524DC1-140C-0080-8121-88490F4D5549",
    "0C524DC1-1456-0080-8121-88490F4D5549",
    "0C524DC1-140D-0080-8121-88490F4D5549",
    "0C524DC1-1439-0080-8121-88490F4D5549",
    "0C524DC1-140E-0080-8121-88490F4D5549",
    "0C524DC1-1421-0080-8121-88490F4D5549",
    "0C524DC1-1410-0080-8121-88490F4D5549",
    "0C524DC1-1411-0080-8121-88490F4D5549",
    "0C524DC1-143F-0080-8121-88490F4D5549",
    "0C524DC1-1412-0080-8121-88490F4D5549",
    "0C524DC1-1427-0080-8121-88490F4D5549",
    "0C524DC1-1426-0080-8121-88490F4D5549",
    "0C524DC1-143E-0080-8121-88490F4D5549",
    "0C524DC1-1413-0080-8121-88490F4D5549",
    "0C524DC1-1414-0080-8121-88490F4D5549",
    "0C524DC1-1415-0080-8121-88490F4D5549",
    "0C524DC1-1416-0080-8121-88490F4D5549",
    "0C524DC1-1816-0080-8121-88490F4D5549",
    "0C524DC1-1418-0080-8121-88490F4D5549",
    "0C524DC1-1419-0080-8121-88490F4D5549",
    "0C524DC1-1401-0080-8121-88490F4D5549",
    "0C524DC1-141B-0080-8121-88490F4D5549",
    "0C524DC1-1424-0080-8121-88490F4D5549",
    "0C524DC1-1C1A-0080-8121-88490F4D5549",
    "0C524DC1-181A-0080-8121-88490F4D5549",
    "0C524DC1-141D-0080-8121-88490F4D5549",
    "0C524DC1-141E-0080-8121-88490F4D5549",
    "0C524DC1-141F-0080-8121-88490F4D5549",
    "0C524DC1-1422-0080-8121-88490F4D5549",
    "0C524DC1-142A-0080-8121-88490F4D5549"
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
        $mediaDir = "C:\Install\Dynamics\CRM2016RTMDan\SrsDataConnector";
    } else {
        $mediaDir = "\\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016RTMDan\SrsDataConnector";
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
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-1406-0080-BFEE-D90853535253}" }
} else {
    $installedProduct = Get-WmiObject Win32_Product -ComputerName $dbHostName -Credential $CRMInstallAccountCredential | ? { $_.IdentifyingNumber -eq "{0C524D71-1406-0080-BFEE-D90853535253}" }
}
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}

Test-InstallDynamics365Update CRM2016Update01Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackUpdate01Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsUpdate01Dan;
Test-InstallDynamics365Update CRM2016ServicePack1Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack1Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack1Dan;
Test-InstallDynamics365Update CRM2016ServicePack1Update01Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack1Update01Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack1Update01Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update01Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update01Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update01Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update02Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update02Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update02Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update03Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update03Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update03Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update04Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update04Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update04Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update05Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update05Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update05Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update06Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update06Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update06Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update07Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update07Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update07Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update08Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update08Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update08Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update09Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update09Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update09Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update10Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update10Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update10Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update11Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update11Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update11Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update12Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update12Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update12Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update13Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update13Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update13Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update14Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update14Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update14Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update15Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update15Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update15Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update16Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update16Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update16Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update17Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update17Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update17Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update18Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update18Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update18Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update19Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update19Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update19Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update21Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update21Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update21Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update22Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update22Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update22Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update23Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update23Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update23Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update24Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update24Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update24Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update25Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update25Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update25Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update26Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update26Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update26Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update27Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update27Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update27Dan;
Test-InstallDynamics365Update CRM2016ServicePack2Update28Dan;
Test-InstallDynamics365LanguageUpdate CRM2016LanguagePackServicePack2Update28Enu;
Test-InstallDynamics365ReportingExtensionsUpdate CRM2016ReportingExtensionsServicePack2Update28Dan;

Exit 0;
