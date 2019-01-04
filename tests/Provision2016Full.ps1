try {
    @(
        "CRM2016",
        "CRM2016LanguagePackSau",
        "CRM2016LanguagePackEus",
        "CRM2016LanguagePackBgr",
        "CRM2016LanguagePackCat",
        "CRM2016LanguagePackChk",
        "CRM2016LanguagePackChs",
        "CRM2016LanguagePackCht",
        "CRM2016LanguagePackCsy",
        "CRM2016LanguagePackDan",
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
        "CRM2016Update01",
        "CRM2016ServicePack1",
        "CRM2016ServicePack1Update01",
        "CRM2016ServicePack2",
        "CRM2016ServicePack2Update01",
        "CRM2016ServicePack2Update02"
    ) | % { Save-Dynamics365Resource -Resource $_ -TargetDirectory C:\Install\Dynamics\$_ }
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
    Install-Dynamics365Server `
        -MediaDir C:\Install\Dynamics\CRM2016 `
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
        -BaseISOCurrencyCode SEK `
        -BaseCurrencyName "Svensk krona" `
        -BaseCurrencySymbol kr `
        -BaseCurrencyPrecision 2 `
        -OrganizationCollation Latin1_General_CI_AI `
        -ReportingUrl http://$dbHostName/ReportServer_SPIntra01 `
        -InstallAccount $CRMInstallAccountCredential
    @(
        "CRM2016",
        "CRM2016LanguagePackSau",
        "CRM2016LanguagePackEus",
        "CRM2016LanguagePackBgr",
        "CRM2016LanguagePackCat",
        "CRM2016LanguagePackChk",
        "CRM2016LanguagePackChs",
        "CRM2016LanguagePackCht",
        "CRM2016LanguagePackCsy",
        "CRM2016LanguagePackDan",
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
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016Update01 -InstallAccount $CRMInstallAccountCredential
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1 -InstallAccount $CRMInstallAccountCredential
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack1Update01 -InstallAccount $CRMInstallAccountCredential
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2 -InstallAccount $CRMInstallAccountCredential
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update01 -InstallAccount $CRMInstallAccountCredential
    Install-Dynamics365Update -MediaDir C:\Install\Dynamics\CRM2016ServicePack2Update02 -InstallAccount $CRMInstallAccountCredential
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
Exit 0;
