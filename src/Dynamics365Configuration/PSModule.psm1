$Dynamics365Resources = Get-Content -Raw -Path "$PSScriptRoot/FileResources.json" | ConvertFrom-Json;
function Get-Dynamics365ResouceUrl
{
    [CmdletBinding()]
    param
    (
        [parameter(Position=0)]
        [ValidateSet(
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
        )]
        [string]
        $Resource
    )
    if ( $resource )
    {
        $Dynamics365Resources.$resource;
    } else {
        Write-Debug "Listing all URLs"
        $Dynamics365Resources | get-member -MemberType NoteProperty | % {
            $Dynamics365Resources.($_.Name);
        }
    }
}

function Save-Dynamics365Resource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0)]
        [ValidateSet(
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
        )]
        [string]
        $Resource,
        [Parameter(Position=1)]
        [string]
        $TargetDirectory
    )
    if ( $resource )
    {
        $resourceUrl = $Dynamics365Resources.$resource;
        if ( $TargetDirectory )
        {
            $directoryPath = $TargetDirectory;
        } else {
            $directoryName = $resource;
            $directoryPath = ".\$directoryName";
            Write-Debug "Directory Path: $directoryPath";
        }
        DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
    } else {
        Write-Debug "Downloading all URLs"
        if ( $TargetDirectory )
        {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
                $resourceUrl = $Dynamics365Resources.($_.Name);
                $directoryName = $_.Name;
                $directoryPath = "$TargetDirectory\$directoryName";
                DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
            }
        } else {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
                $resourceUrl = $Dynamics365Resources.($_.Name);
                $directoryName = $_.Name;
                $directoryPath = ".\$directoryName";
                Write-Host "directoryPath: $directoryPath"
                DownloadAndUnpack-Dynamics365Resource -ResourceUrl $resourceUrl -DirectoryPath $directoryPath;
            }
        }
    }
}

function DownloadAndUnpack-Dynamics365Resource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,
        Position=0)]
        [string]
        $ResourceUrl,
        [Parameter(Mandatory=$true,
        Position=1)]
        [string]
        $DirectoryPath
    )
    if ( !( Get-ChildItem $directoryPath -ErrorAction Ignore ) ) {
        New-Item $directoryPath -ItemType Directory -Force | Out-Null;
        $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $resourceFileName = $matches[0];
        $resourceFileName -match '\.[A-Za-z0-9]+$' | Out-Null
        if ( $matches[0] -eq ".exe" )
        {
            $tempDirName = [guid]::NewGuid().Guid;
            $tempDirPath = "$env:Temp\$tempDirName";
            $filePath = "$tempDirPath\$resourceFileName";
            New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
            Write-Host "Downloading $resourceUrl to $filePath";
            Start-BitsTransfer -Source $resourceUrl -Destination $filePath;
            Write-Host "Unpacking $filePath to $directoryPath";
            Start-Process -FilePath $filePath -ArgumentList "/extract:$directoryPath /passive /quiet" -Wait -NoNewWindow;
            Sleep 10;
            Remove-Item $filePath;
        } else {
            $filePath = "$directoryPath\$resourceFileName";
            Start-BitsTransfer -Source $resourceUrl -Destination $filePath;
        }
    } else {
        Write-Host "The target directory is not empty. Skipped downloading."
    }
}

function Install-Dynamics365Prerequisites {
    param (
        [string]$DynamicsInstallationMediaDirectoryPath,
        [ValidateSet(
            'SQLNCli2012SP4',
            'SQLSysClrTypes2016',
            'SharedManagementObjects2016',
            'MSODBCSQL',
            'SQLNCli2018R2',
            'SQLSysClrTypes2012',
            'SharedManagementObjects2012',
            'ReportViewer2012'
        )]
        [string]
        $Dymanics365PrerequisiteName,
        [string]$DynamicsPrerequisiteFilePath
    )
    if ( $dymanics365PrerequisiteName )
    {

    }
}

Export-ModuleMember -Variable Dynamics365Resources
Export-ModuleMember -Function Get-Dynamics365ResouceUrl
Export-ModuleMember -Function Save-Dynamics365Resource
Export-ModuleMember -Function Install-Dynamics365Prerequisites
