try {
    @(
        "Dynamics365Server90",
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
        "Dynamics365Server90LanguagePackEnu",
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
        -MediaDir C:\Install\Dynamics\Dynamics365Server90 `
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
        -BaseISOCurrencyCode SEK `
        -BaseCurrencyName "Svensk krona" `
        -BaseCurrencySymbol kr `
        -BaseCurrencyPrecision 2 `
        -OrganizationCollation Latin1_General_CI_AI `
        -ReportingUrl http://$dbHostName/ReportServer_SPIntra01 `
        -InstallAccount $CRMInstallAccountCredential
    @(
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
        "Dynamics365Server90LanguagePackEnu",
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
Exit 0;
