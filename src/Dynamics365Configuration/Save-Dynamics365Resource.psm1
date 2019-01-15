Import-Module $PSScriptRoot\DownloadAndUnpack-Dynamics365Resource.psm1
function Save-Dynamics365Resource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0)]
        [ValidateSet(
            'Dynamics365Server90',
            'VisualCPlusPlusRuntime',
            'VisualCPlusPlus2010Runtime',
            'SQLNCli2012SP4',
            'SQLSysClrTypes2016',
            'SharedManagementObjects2016',
            'MSODBCSQL',
            'Dynamics365Server90LanguagePackSau',
            'Dynamics365Server90LanguagePackEus',
            'Dynamics365Server90LanguagePackBgr',
            'Dynamics365Server90LanguagePackCat',
            'Dynamics365Server90LanguagePackChk',
            'Dynamics365Server90LanguagePackChs',
            'Dynamics365Server90LanguagePackCht',
            'Dynamics365Server90LanguagePackHrv',
            'Dynamics365Server90LanguagePackCsy',
            'Dynamics365Server90LanguagePackDan',
            'Dynamics365Server90LanguagePackNld',
            'Dynamics365Server90LanguagePackEti',
            'Dynamics365Server90LanguagePackFin',
            'Dynamics365Server90LanguagePackFra',
            'Dynamics365Server90LanguagePackGlc',
            'Dynamics365Server90LanguagePackDeu',
            'Dynamics365Server90LanguagePackEll',
            'Dynamics365Server90LanguagePackHeb',
            'Dynamics365Server90LanguagePackHin',
            'Dynamics365Server90LanguagePackHun',
            'Dynamics365Server90LanguagePackInd',
            'Dynamics365Server90LanguagePackIta',
            'Dynamics365Server90LanguagePackJpn',
            'Dynamics365Server90LanguagePackKkz',
            'Dynamics365Server90LanguagePackKor',
            'Dynamics365Server90LanguagePackLvi',
            'Dynamics365Server90LanguagePackLth',
            'Dynamics365Server90LanguagePackMsl',
            'Dynamics365Server90LanguagePackNor',
            'Dynamics365Server90LanguagePackPlk',
            'Dynamics365Server90LanguagePackPtb',
            'Dynamics365Server90LanguagePackPtg',
            'Dynamics365Server90LanguagePackRom',
            'Dynamics365Server90LanguagePackRus',
            'Dynamics365Server90LanguagePackSrb',
            'Dynamics365Server90LanguagePackSrl',
            'Dynamics365Server90LanguagePackSky',
            'Dynamics365Server90LanguagePackSlv',
            'Dynamics365Server90LanguagePackEsn',
            'Dynamics365Server90LanguagePackSve',
            'Dynamics365Server90LanguagePackTha',
            'Dynamics365Server90LanguagePackTrk',
            'Dynamics365Server90LanguagePackUkr',
            'Dynamics365Server90LanguagePackVit',
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
            'CRM2016ReportingServicesUpdate01',
            'CRM2016ServicePack1',
            'CRM2016ReportingServicesServicePack1',
            'CRM2016ServicePack1Update01',
            'CRM2016ReportingServicesServicePack1Update01',
            'CRM2016ServicePack2',
            'CRM2016ReportingServicesServicePack2',
            'CRM2016ServicePack2Update01',
            'CRM2016ReportingServicesServicePack2Update01',
            'CRM2016ServicePack2Update02',
            'CRM2016ReportingServicesServicePack2Update02'
        )]
        [string]
        $Resource,
        [Parameter(Position=1)]
        [string]
        $TargetDirectory
    )
    if ( $resource )
    {
        $resourceUrl = $Dynamics365Resources.$resource.URL;
        if ( $TargetDirectory )
        {
            $directoryPath = $TargetDirectory;
        } else {
            $directoryName = $resource;
            $directoryPath = ".\$directoryName";
            Write-Debug "Directory Path: $directoryPath";
        }
        DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath -ExpectedFileChecksum $Dynamics365Resources.$resource.checksum;
    } else {
        Write-Debug "Downloading all URLs"
        if ( $TargetDirectory )
        {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
                $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
                $directoryName = $_.Name;
                $directoryPath = "$TargetDirectory\$directoryName";
                DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
            }
        } else {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
                $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
                $directoryName = $_.Name;
                $directoryPath = ".\$directoryName";
                Write-Host "directoryPath: $directoryPath"
                DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
            }
        }
    }
}
