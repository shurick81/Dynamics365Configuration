Save-Dynamics365Resource;
$expectedDirectories = @(
    'Dynamics365Server90',
    'SQLNCli2012SP4',
    'SQLSysClrTypes2016',
    'SharedManagementObjects2016',
    'MSODBCSQL',
    'CRM2016',
    'SQLNCli2018R2',
    'SQLSysClrTypes2012',
    'SharedManagementObjects2012',
    'ReportViewer2012',
    'CRM2016LanguagePackSau',
    'CRM2016LanguagePackEus',
    'CRM2016LanguagePackBgr',
    'CRM2016LanguagePackCat',
    'CRM2016LanguagePackChk',
    'CRM2016LanguagePackChs',
    'CRM2016LanguagePackCht',
    'CRM2016LanguagePackCsy',
    'CRM2016LanguagePackDan',
    'CRM2016LanguagePackNld',
    'CRM2016LanguagePackEti',
    'CRM2016LanguagePackFin',
    'CRM2016LanguagePackFra',
    'CRM2016LanguagePackGlc',
    'CRM2016LanguagePackDeu',
    'CRM2016LanguagePackEll',
    'CRM2016LanguagePackHeb',
    'CRM2016LanguagePackHin',
    'CRM2016LanguagePackHun',
    'CRM2016LanguagePackInd',
    'CRM2016LanguagePackIta',
    'CRM2016LanguagePackJpn',
    'CRM2016LanguagePackKkz',
    'CRM2016LanguagePackKor',
    'CRM2016LanguagePackLvi',
    'CRM2016LanguagePackLth',
    'CRM2016LanguagePackMsl',
    'CRM2016LanguagePackNor',
    'CRM2016LanguagePackPlk',
    'CRM2016LanguagePackPtb',
    'CRM2016LanguagePackPtg',
    'CRM2016LanguagePackRom',
    'CRM2016LanguagePackRus',
    'CRM2016LanguagePackSrb',
    'CRM2016LanguagePackSrl',
    'CRM2016LanguagePackSky',
    'CRM2016LanguagePackSlv',
    'CRM2016LanguagePackEsn',
    'CRM2016LanguagePackSve',
    'CRM2016LanguagePackTha',
    'CRM2016LanguagePackTrk',
    'CRM2016LanguagePackUkr',
    'CRM2016LanguagePackVit',
    'CRM2016Update01',
    'CRM2016ServicePack1',
    'CRM2016ServicePack1Update01',
    'CRM2016ServicePack2',
    'CRM2016ServicePack2Update01',
    'CRM2016ServicePack2Update02'
)
$expectedDirectories | % {
    $expectedDirectory = ".\$_";
    if ( !( Get-ChildItem $expectedDirectory -ErrorAction Ignore ) ) {
        Write-Host "Files not found in $expectedDirectory"
        Write-Host "Test not OK"
        Remove-Item $expectedDirectory -Recurse -Force;    
        Exit 1;
    } else {
        Write-Host "Files found in $expectedDirectory"
    }
    Remove-Item $expectedDirectory -Recurse -Force;    
}
Write-Host "Test OK"
Exit 0;