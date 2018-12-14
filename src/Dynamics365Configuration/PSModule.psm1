$Dynamics365Resources = Get-Content -Raw -Path "$PSScriptRoot/FileResources.json" | ConvertFrom-Json;
function Get-Dynamics365ResouceUrl
{
    [CmdletBinding()]
    param
    (
        [parameter(Position=0)]
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
            'Dynamics365Server90LanguagePackEnu',
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
            'Dynamics365Server90LanguagePackEnu',
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
        if ( ( $matches[0] -eq ".exe" ) -and ( $resourceFileName -ne "vcredist_x64.exe" ) )
        {
            $tempDirName = [guid]::NewGuid().Guid;
            $tempDirPath = "$env:Temp\$tempDirName";
            $filePath = "$tempDirPath\$resourceFileName";
            New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
            Write-Host "Downloading $resourceUrl to $filePath";
            Start-BitsTransfer -Source $resourceUrl -Destination $filePath;
            Write-Host "Unpacking $filePath to $directoryPath";
            Start-Process -FilePath $filePath -ArgumentList "/extract:$directoryPath /passive /quiet" -Wait -NoNewWindow;
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
        [ValidateSet(
            'VisualCPlusPlusRuntime',
            'VisualCPlusPlus2010Runtime',
            'SQLNCli2012SP4',
            'SQLSysClrTypes2016',
            'SharedManagementObjects2016',
            'MSODBCSQL',
            'SQLNCli2018R2',
            'SQLSysClrTypes2012',
            'SharedManagementObjects2012',
            'ReportViewer2012'
            #, 'AppErrorReporting'
        )]
        [string]
        $Dymanics365PrerequisiteName,
        [string]$DynamicsPrerequisiteFilePath = "."
    )
    if ( $dymanics365PrerequisiteName )
    {
        $tempDirPath = $false;
        Write-Debug "Installing $dymanics365PrerequisiteName prerequisite"
        switch ( $dymanics365PrerequisiteName ) {
            { ( $_ -eq 'VisualCPlusPlusRuntime' ) -or ( $_ -eq 'VisualCPlusPlus2010Runtime' ) } {
                $resourceUrl = $Dynamics365Resources.$dymanics365PrerequisiteName;
                $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
                $defaultFileName = $matches[0];
                $defaultDirectoryName = "$dymanics365PrerequisiteName";
            }
            #"AppErrorReporting" {
            #    $defaultFileName = "dw20sharedamd64.msi";
            #    if ( Test-Path "$dynamicsPrerequisiteFilePath\Dynamics365Server90" )
            #    {
            #        $defaultDirectoryName = "Dynamics365Server90\DW";
            #    } else {
            #        $defaultDirectoryName = "CRM2016\DW";
            #    }
            #}
            Default {
                $resourceUrl = $Dynamics365Resources.$dymanics365PrerequisiteName;
                $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
                $defaultFileName = $matches[0];
                $defaultDirectoryName = $dymanics365PrerequisiteName;
            }
        }
        $resourcePathItem = Get-Item $dynamicsPrerequisiteFilePath;
        if ( !$resourcePathItem ) { throw "Specified file or directory '$dynamicsPrerequisiteFilePath' could not be found" }
        $dynamicsPrerequisiteFilePath = ( Resolve-Path $dynamicsPrerequisiteFilePath ).Path
        if ( $resourcePathItem.PSIsContainer )
        {
            Write-Debug "The path represents a directory";
            $resourceFileName = $defaultFileName;
            $resourcePathItem = Get-Item "$dynamicsPrerequisiteFilePath\$resourceFileName" -ErrorAction Ignore;
            if ( $resourcePathItem )
            {
                $fullFilePath = "$dynamicsPrerequisiteFilePath\$resourceFileName";
            } else {
                $resourcePathItem = Get-Item "$dynamicsPrerequisiteFilePath\$defaultDirectoryName\$resourceFileName" -ErrorAction Ignore;
                if ( $resourcePathItem ) {
                    $fullFilePath = "$dynamicsPrerequisiteFilePath\$defaultDirectoryName\$resourceFileName";
                } else {
                    Write-Debug "Specified file or directory '$dynamicsPrerequisiteFilePath' could not be found, downloading now";
                    $tempDirName = [guid]::NewGuid().Guid;
                    $tempDirPath = "$env:Temp\$tempDirName";
                    Save-Dynamics365Resource -Resource $dymanics365PrerequisiteName -TargetDirectory $tempDirPath
                    $fullFilePath = "$tempDirPath\$resourceFileName";
                }
            }
        } else {
            Write-Debug "The path represents a file";
            $fullFilePath = $dynamicsPrerequisiteFilePath;
            $resourceFileName = Split-Path $fullFilePath -Leaf;
        }

        $dataStamp = get-date -Format yyyyMMddTHHmmss;
        $logFile = '{0}-{1}.log' -f $resourceFileName,$dataStamp;
        Write-Host "$(Get-Date) Starting $fullFilePath. Log will be saved in $( Resolve-Path . )\$logFile";
        switch ( $dymanics365PrerequisiteName ) {
            { ( $_ -eq 'VisualCPlusPlusRuntime' ) -or ( $_ -eq 'VisualCPlusPlus2010Runtime' ) } {
                Start-Process $fullFilePath -ArgumentList "/q /norestart" -Wait -NoNewWindow;
            }
            #"AppErrorReporting" {
            #    $MSIArguments = @(
            #        "/i"
            #        ( '"{0}"' -f $fullFilePath )
            #        "/qn"
            #        "/norestart"
            #        "/LV*"
            #        $logFile
            #        "REBOOT=ReallySuppress"
            #        "APPGUID={0C524D55-1409-0080-BD7E-530E52560E52}"
            #        "REINSTALL=ALL"
            #        "REINSTALLMODE=vomus"
            #    )
            #    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow;
            #    break;
            #}
            { ( $_ -eq 'SQLNCli2012SP4' ) -or ( $_ -eq 'SQLNCli2018R2' ) } {
                $MSIArguments = @(
                    "/qn"
                    "/i"
                    ( '"{0}"' -f $fullFilePath )
                    "IACCEPTSQLNCLILICENSETERMS=YES"
                    "/L*v"
                    $logFile
                )
                Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow;
                break;
            }
            "MSODBCSQL" {
                $MSIArguments = @(
                    "/qn"
                    "/i"
                    ( '"{0}"' -f $fullFilePath )
                    "IACCEPTMSODBCSQLLICENSETERMS=YES"
                    "/L*v"
                    $logFile
                )
                Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow;
                break;
            }
            Default {
                $MSIArguments = @(
                    "/i"
                    ( '"{0}"' -f $fullFilePath )
                    "/qn"
                    "/norestart"
                    "/L*v"
                    $logFile
                )
                Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow;
            }
        }
        if ( $tempDirPath ) {
            Remove-Item $tempDirPath -Recurse -Force
        }
    } else {
        Write-Host "Dymanics365PrerequisiteName is not specified"
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'VisualCPlusPlusRuntime'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'VisualCPlusPlus2010Runtime'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'SQLNCli2012SP4'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'SQLSysClrTypes2016'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'SharedManagementObjects2016'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'MSODBCSQL'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'SQLNCli2018R2'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'SQLSysClrTypes2012'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'SharedManagementObjects2012'
        Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'ReportViewer2012'
        #Install-Dynamics365Prerequisites -Dymanics365PrerequisiteName 'AppErrorReporting'
    }
}

function Install-Dynamics365Server {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $MediaDir,
        [Parameter(Mandatory=$true)]
        [string]
        $LicenseKey,
        [Parameter(Mandatory=$true)]
        [string]
        $InstallDir,
        [Parameter(Mandatory=$true)]
        [switch]
        $CreateDatabase,
        [Parameter(Mandatory=$true)]
        [string]
        $SqlServer,
        [Parameter(Mandatory=$true)]
        [string]
        $PrivUserGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $SQLAccessGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $UserGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $ReportingGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $PrivReportingGroup,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $CrmServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $DeploymentServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $SandboxServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $VSSWriterServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $AsyncServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $MonitoringServiceAccount,
        [Parameter(Mandatory=$true)]
        [switch]
        $CreateWebSite,
        [Parameter(Mandatory=$true)]
        [int]
        $WebSitePort,
        [Parameter(Mandatory=$true)]
        [string]
        $WebSiteUrl,
        [string]
        $IncomingExchangeServer,
        [Parameter(Mandatory=$true)]
        [string]
        $Organization,
        [Parameter(Mandatory=$true)]
        [string]
        $OrganizationUniqueName,
        [Parameter(Mandatory=$true)]
        [string]
        $BaseISOCurrencyCode,
        [Parameter(Mandatory=$true)]
        [string]
        $BaseCurrencyName,
        [Parameter(Mandatory=$true)]
        [string]
        $BaseCurrencySymbol,
        [Parameter(Mandatory=$true)]
        [int]
        $BaseCurrencyPrecision,
        [Parameter(Mandatory=$true)]
        [string]
        $OrganizationCollation,
        [Parameter(Mandatory=$true)]
        [string]
        $ReportingUrl,
        [switch]
        $SQM = $false,
        [switch]
        $MUOptin = $false,
        [switch]
        $Reboot = $false,
        [pscredential]
        $InstallAccount
    )
    $xml = [xml]"";
    $crmSetupElement = $xml.CreateElement( "CRMSetup" );
        $serverElement = $xml.CreateElement( "Server" );
            $patchElement = $xml.CreateElement( "Patch" );
                $patchElement.SetAttribute( "Update", $false ) | Out-Null;
            $serverElement.AppendChild( $patchElement ) | Out-Null;
            $licenseKeyElement = $xml.CreateElement( "LicenseKey" );
                $licenseKeyElement.InnerText = $licenseKey;
            $serverElement.AppendChild( $licenseKeyElement ) | Out-Null;
            $installDirElement = $xml.CreateElement( "InstallDir" );
                $installDirElement.InnerText = $installDir;
            $serverElement.AppendChild( $installDirElement ) | Out-Null;
            $databaseElement = $xml.CreateElement( "Database" );
                $databaseElement.SetAttribute( "create", $createDatabase ) | Out-Null;
            $serverElement.AppendChild( $databaseElement ) | Out-Null;
            $SQLServerElement = $xml.CreateElement( "SqlServer" );
                $SQLServerElement.InnerText = $SQLServer;
            $serverElement.AppendChild( $SQLServerElement ) | Out-Null;
            $groupsElement = $xml.CreateElement( "Groups" );
                $groupsElement.SetAttribute( "autogroupmanagementoff", $false ) | Out-Null;
                $privUserGroupElement = $xml.CreateElement( "PrivUserGroup" );
                    $privUserGroupElement.InnerText = $privUserGroup;
                $groupsElement.AppendChild( $privUserGroupElement ) | Out-Null;
                $SQLAccessGroupElement = $xml.CreateElement( "SQLAccessGroup" );
                    $SQLAccessGroupElement.InnerText = $SQLAccessGroup;
                $groupsElement.AppendChild( $SQLAccessGroupElement ) | Out-Null;
                $userGroupElement = $xml.CreateElement( "UserGroup" );
                    $userGroupElement.InnerText = $userGroup;
                $groupsElement.AppendChild( $userGroupElement ) | Out-Null;
                $reportingGroupElement = $xml.CreateElement( "ReportingGroup" );
                    $reportingGroupElement.InnerText = $reportingGroup;
                $groupsElement.AppendChild( $reportingGroupElement ) | Out-Null;
                $privReportingGroupElement = $xml.CreateElement( "PrivReportingGroup" );
                    $privReportingGroupElement.InnerText = $privReportingGroup;
                $groupsElement.AppendChild( $privReportingGroupElement ) | Out-Null;
            $serverElement.AppendChild( $groupsElement ) | Out-Null;
            $CRMServiceAccountElement = $xml.CreateElement( "CrmServiceAccount" );
                $CRMServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                    $serviceAccountLoginElement.InnerText = $CRMServiceAccount.UserName;
                $CRMServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                    $serviceAccountPasswordElement.InnerText = $CRMServiceAccount.GetNetworkCredential().Password;
                $CRMServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
            $serverElement.AppendChild( $CRMServiceAccountElement ) | Out-Null;
            $deploymentServiceAccountElement = $xml.CreateElement( "DeploymentServiceAccount" );
                $deploymentServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                    $serviceAccountLoginElement.InnerText = $deploymentServiceAccount.UserName;
                $deploymentServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                    $serviceAccountPasswordElement.InnerText = $deploymentServiceAccount.GetNetworkCredential().Password;
                $deploymentServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
            $serverElement.AppendChild( $deploymentServiceAccountElement ) | Out-Null;
            $sandboxServiceAccountElement = $xml.CreateElement( "SandboxServiceAccount" );
                $sandboxServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                    $serviceAccountLoginElement.InnerText = $sandboxServiceAccount.UserName;
                $sandboxServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                    $serviceAccountPasswordElement.InnerText = $sandboxServiceAccount.GetNetworkCredential().Password;
                $sandboxServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
            $serverElement.AppendChild( $sandboxServiceAccountElement ) | Out-Null;
            $VSSWriterServiceAccountElement = $xml.CreateElement( "VSSWriterServiceAccount" );
                $VSSWriterServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                    $serviceAccountLoginElement.InnerText = $VSSWriterServiceAccount.UserName;
                $VSSWriterServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                    $serviceAccountPasswordElement.InnerText = $VSSWriterServiceAccount.GetNetworkCredential().Password;
                $VSSWriterServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
            $serverElement.AppendChild( $VSSWriterServiceAccountElement ) | Out-Null;
            $asyncServiceAccountElement = $xml.CreateElement( "AsyncServiceAccount" );
                $asyncServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                    $serviceAccountLoginElement.InnerText = $asyncServiceAccount.UserName;
                $asyncServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                    $serviceAccountPasswordElement.InnerText = $asyncServiceAccount.GetNetworkCredential().Password;
                $asyncServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
            $serverElement.AppendChild( $asyncServiceAccountElement ) | Out-Null;
            $monitoringServiceAccountElement = $xml.CreateElement( "MonitoringServiceAccount" );
                $monitoringServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                    $serviceAccountLoginElement.InnerText = $monitoringServiceAccount.UserName;
                $monitoringServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                    $serviceAccountPasswordElement.InnerText = $monitoringServiceAccount.GetNetworkCredential().Password;
                $monitoringServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
            $serverElement.AppendChild( $monitoringServiceAccountElement ) | Out-Null;
            $webSiteUrlElement = $xml.CreateElement( "WebsiteUrl" );
                $webSiteUrlElement.SetAttribute( "create", $createWebSite ) | Out-Null;
                $webSiteUrlElement.SetAttribute( "port", $webSitePort ) | Out-Null;
                $webSiteUrlElement.InnerText = $webSiteUrl;
            $serverElement.AppendChild( $webSiteUrlElement ) | Out-Null;
            $emailElement = $xml.CreateElement( "Email" );
                $incomingExchangeServerElement = $xml.CreateElement( "IncomingExchangeServer" );
                    $incomingExchangeServerElement.SetAttribute( "name", $incomingExchangeServer ) | Out-Null;
                $emailElement.AppendChild( $incomingExchangeServerElement ) | Out-Null;
            $serverElement.AppendChild( $emailElement ) | Out-Null;
            $organizationUniqueNameElement = $xml.CreateElement( "OrganizationUniqueName" );
                $organizationUniqueNameElement.InnerText = $organizationUniqueName;
            $serverElement.AppendChild( $organizationUniqueNameElement ) | Out-Null;
            $organizationElement = $xml.CreateElement( "Organization" );
                $organizationElement.InnerText = $organization;
            $serverElement.AppendChild( $organizationElement ) | Out-Null;
            $baseCurrencyElement = $xml.CreateElement( "basecurrency" );
                $baseCurrencyElement.SetAttribute( "isocurrencycode", $baseISOCurrencyCode ) | Out-Null;
                $baseCurrencyElement.SetAttribute( "currencyname", $baseCurrencyName ) | Out-Null;
                $baseCurrencyElement.SetAttribute( "currencysymbol", $baseCurrencySymbol ) | Out-Null;
                $baseCurrencyElement.SetAttribute( "currencyprecision", $baseCurrencyPrecision ) | Out-Null;
            $serverElement.AppendChild( $baseCurrencyElement ) | Out-Null;
            $organizationCollationElement = $xml.CreateElement( "OrganizationCollation" );
                $organizationCollationElement.InnerText = $organizationCollation;
            $serverElement.AppendChild( $organizationCollationElement ) | Out-Null;
            $reportingElement = $xml.CreateElement( "Reporting" );
                $reportingElement.SetAttribute( "URL", $ReportingUrl ) | Out-Null;
            $serverElement.AppendChild( $reportingElement ) | Out-Null;
            $SQMElement = $xml.CreateElement( "SQM" );
                $SQMElement.SetAttribute( "optin", $SQM ) | Out-Null;
            $serverElement.AppendChild( $SQMElement ) | Out-Null;
            $MUOptinElement = $xml.CreateElement( "muoptin" );
                $MUOptinElement.SetAttribute( "optin", $MUOptin ) | Out-Null;
            $serverElement.AppendChild( $MUOptinElement ) | Out-Null;
            $remoteInstallElement = $xml.CreateElement( "remoteinstall" );
                $remoteInstallElement.InnerText = $true;
            $serverElement.AppendChild( $remoteInstallElement ) | Out-Null;
            $rebootElement = $xml.CreateElement( "Reboot" );
                $rebootElement.InnerText = $reboot;
            $serverElement.AppendChild( $rebootElement ) | Out-Null;
        $crmSetupElement.AppendChild( $serverElement ) | Out-Null;
    $xml.AppendChild( $crmSetupElement ) | Out-Null;

    $stringWriter = New-Object System.IO.StringWriter;
    $xmlWriter = New-Object System.Xml.XmlTextWriter $stringWriter;
    $xmlWriter.Formatting = "indented";
    $xml.WriteTo( $xmlWriter );
    $xmlWriter.Flush();
    $stringWriter.Flush();

    $localInstallationScriptBlock = {
        param( $mediaDir, $xmlConfig )
        $tempFileName = [guid]::NewGuid().Guid;
        $tempFilePath = "$env:Temp\$tempFileName.xml";
        Write-Host "$(Get-Date) Saving configuration temporary to $tempFilePath";
        Set-Content -Path $tempFilePath -Value $xmlConfig;
        Write-Host "$(Get-Date) Starting $mediaDir\SetupServer.exe";
        $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
        $logFileName = "$env:Temp\CRMInstallationLog_$timeStamp.txt";
        $installCrmScript = {
            param( $mediaDir, $tempFilePath, $logFileName );
            Write-Host "Start-Process '$mediaDir\SetupServer.exe' -ArgumentList '/Q /config $tempFilePath /L $logFileName' -Wait;";
            Start-Process "$mediaDir\SetupServer.exe" -ArgumentList "/Q /config $tempFilePath /L $logFileName" -Wait;
        }
        $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $mediaDir, $tempFilePath, $logFileName;
        Write-Host "$(Get-Date) Started installation job, log will be saved in $logFileName";
        While ( $job.State -ne "Completed" )
        {
            Write-Host "$(Get-Date) Waiting until CRM installation job is done";
            Sleep 60;
        }
        Write-Host "$(Get-Date) Job is complete, output:";
        Write-Output ( Receive-Job $job );
        Remove-Job $job;
        Remove-Item $tempFilePath;
    }
    if ( $installAccount )
    {
        Invoke-Command -ScriptBlock $localInstallationScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP -ArgumentList $mediaDir, $stringWriter.ToString();
    } else {
        Invoke-Command -ScriptBlock $localInstallationScriptBlock -ArgumentList $mediaDir, $stringWriter.ToString();
    }
}

function Install-Dynamics365Language {
    param (
        [parameter(Position=0,
        Mandatory=$true)]
        [string]
        $MediaDir
    )
    $msiFile = Get-ChildItem "$mediaDir\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -eq 1 )
    {
        $msiFullName = $msiFile.FullName;
        Write-Host "$(Get-Date) Starting $msiFullName";

        $logFile = '{0}-{1}.log' -f $msiFile.Name, $DataStamp;
        $MSIArguments = @(
            "/i"
            ( '"{0}"' -f $msiFullName )
            "/qn"
            "/norestart"
            "/L*v"
            $logFile
        )
        Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow;
        Write-Host "$(Get-Date) Finished C:\Install\CRM\CRM2016-Mui-SVE-amd64\MuiSetup_1053_amd64.msi";
    } else {
        Write-Host "$(Get-Date) No or too many $mediaDir\MuiSetup_????_amd64.msi files were found";
    }
}

function Install-Dynamics365Update {
    param (
        [parameter(Position=0,
        Mandatory=$true)]
        [string]
        $MediaDir,
        [pscredential]
        $InstallAccount
    )
    $localInstallationScriptBlock = {
        param( $mediaDir )
        Write-Host "$(Get-Date) Starting $mediaDir\crmupdatewrapper.exe";
        $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
        $logFileName = "$env:Temp\CRMUpdateInstallationLog_$timeStamp.txt";
        $installCrmScript = {
            param( $mediaDir, $logFileName );
            Write-Host "Start-Process '$mediaDir\crmupdatewrapper.exe' -ArgumentList '/q /log $logFileName /norestart' -Wait;";
            Start-Process "$mediaDir\crmupdatewrapper.exe" -ArgumentList "/q /log $logFileName /norestart" -Wait;
        }
        $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $mediaDir, $logFileName;
        Write-Host "$(Get-Date) Started installation job, log will be saved in $logFileName";
        While ( $job.State -ne "Completed" )
        {
            Write-Host "$(Get-Date) Waiting until CRM update installation job is done";
            Sleep 60;
        }
        Write-Host "$(Get-Date) Job is complete, output:";
        Write-Output ( Receive-Job $job );
        Remove-Job $job;
    }
    if ( $installAccount )
    {
        Invoke-Command -ScriptBlock $localInstallationScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP -ArgumentList $mediaDir;
    } else {
        Invoke-Command -ScriptBlock $localInstallationScriptBlock -ArgumentList $mediaDir;
    }
}


Export-ModuleMember -Variable Dynamics365Resources
Export-ModuleMember -Function Get-Dynamics365ResouceUrl
Export-ModuleMember -Function Save-Dynamics365Resource
Export-ModuleMember -Function Install-Dynamics365Prerequisites
Export-ModuleMember -Function Install-Dynamics365Server
Export-ModuleMember -Function Install-Dynamics365Language
Export-ModuleMember -Function Install-Dynamics365Update