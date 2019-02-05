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

try {
    @(
        "Dynamics365Server90RTMFra",
        "Dynamics365Server90LanguagePackEnu",
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
    ) | % { Save-Dynamics365Resource -Resource $_ -TargetDirectory C:\Install\Dynamics\$_ }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
@(
    "Dynamics365Server90RTMFra",
    "Dynamics365Server90LanguagePackEnu",
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
) | % {
    if ( Get-ChildItem C:\Install\Dynamics\$_ ) {
        Write-Host "Test OK";
    } else {
        Write-Host "Expected files are not found in C:\Install\Dynamics\$_, test is not OK";
        Exit 1;
    }
}

try {
    Install-Dynamics365Server `
        -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMFra `
        -LicenseKey KKNV2-4YYK8-D8HWD-GDRMW-29YTW `
        -InstallDir "c:\Program Files\Microsoft Dynamics CRM" `
        -CreateDatabase `
        -SqlServer $dbHostName\SPIntra01 `
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
        -OrganizationCollation French_CI_AI `
        -ReportingUrl http://$dbHostName/ReportServer_SPIntra01 `
        -InstallAccount $CRMInstallAccountCredential
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
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $testResponse -eq "9.0.2.3034" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        Install-Dynamics365ReportingExtensions `
            -MediaDir C:\Install\Dynamics\Dynamics365Server90RTMFra\SrsDataConnector `
            -InstanceName SPIntra01 `
            -InstallAccount $CRMInstallAccountCredential
    } else {
        Install-Dynamics365ReportingExtensions `
            -MediaDir \\$env:COMPUTERNAME\c$\Install\Dynamics\Dynamics365Server90RTMFra\SrsDataConnector `
            -ConfigDBServer $dbHostName `
            -InstanceName SPIntra01 `
            -InstallAccount $CRMInstallAccountCredential
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
if ( $dbHostName -eq $env:COMPUTERNAME ) {
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{0C524D71-140C-0090-BFEE-D90853535253}" }
} else {
    $installedProduct = Get-WmiObject Win32_Product -ComputerName $dbHostName -Credential $CRMInstallAccountCredential | ? { $_.IdentifyingNumber -eq "{0C524D71-140C-0090-BFEE-D90853535253}" }
}
if ( $installedProduct ) {
    Write-Host "Test OK";
} else {
    Write-Host "Expected software is not installed, test is not OK";
    Exit 1;
}

try {
    @(
        "Dynamics365Server90LanguagePackEnu",
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
    "0C524DC1-1409-0090-8121-88490F4D5549",
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

Exit 0;
