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
        "CRM2016RTMDan",
        "CRM2016LanguagePackEnu",
        "CRM2016LanguagePackSau",
        "CRM2016LanguagePackEus",
        "CRM2016LanguagePackBgr",
        "CRM2016LanguagePackCat",
        "CRM2016LanguagePackChk",
        "CRM2016LanguagePackChs",
        "CRM2016LanguagePackCht",
        "CRM2016LanguagePackCsy",
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
        "CRM2016ServicePack1Dan",
        "CRM2016ServicePack1Update01Dan",
        "CRM2016ServicePack2Dan",
        "CRM2016ServicePack2Update01Dan",
        "CRM2016ServicePack2Update02Dan"
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
    "CRM2016LanguagePackCsy",
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
        -MediaDir C:\Install\Dynamics\CRM2016RTMDan `
        -LicenseKey WCPQN-33442-VH2RQ-M4RKF-GXYH4 `
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
        -OrganizationCollation Danish_Norwegian_CI_AI `
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $testResponse -eq "8.0.0.1088" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    if ( $dbHostName -eq $env:COMPUTERNAME ) {
        Install-Dynamics365ReportingExtensions `
            -MediaDir C:\Install\Dynamics\CRM2016RTMDan\SrsDataConnector `
            -InstanceName SPIntra01 `
            -InstallAccount $CRMInstallAccountCredential
    } else {
        Install-Dynamics365ReportingExtensions `
            -MediaDir \\$env:COMPUTERNAME\c$\Install\Dynamics\CRM2016RTMDan\SrsDataConnector `
            -ConfigDBServer $dbHostName `
            -InstanceName SPIntra01 `
            -InstallAccount $CRMInstallAccountCredential
    }
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
        "CRM2016LanguagePackCsy",
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
    "0C524DC1-1408-0080-8121-88490F4D5549",
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
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016Update01Dan -InstallAccount $CRMInstallAccountCredential
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP;
if ( $testResponse -eq "8.0.1.79" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1Dan -InstallAccount $CRMInstallAccountCredential
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $testResponse -eq "8.1.0.359" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1Update01Dan -InstallAccount $CRMInstallAccountCredential
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $testResponse -eq "8.1.1.1005" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Dan -InstallAccount $CRMInstallAccountCredential
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $testResponse -eq "8.2.0.749" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update01Dan -InstallAccount $CRMInstallAccountCredential
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $testResponse -eq "8.2.1.176" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

try {
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update02Dan -InstallAccount $CRMInstallAccountCredential
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
    }
}
$testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $CRMInstallAccountCredential -Authentication CredSSP
if ( $testResponse -eq "8.2.2.112" )
{
    Write-Host "Test OK";
} else {
    Write-Host "Software installed version is '$testResponse'. Test is not OK"
    Exit 1;
}

Exit 0;
