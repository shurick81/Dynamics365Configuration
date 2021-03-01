function Install-Dynamics365Prerequisite {
    param (
        [ValidateSet(
            'VisualCPlusPlusRuntime',
            'VisualCPlusPlus2010Runtime',
            'SQLNCli2012SP4',
            'SQLSysClrTypes2016',
            'SharedManagementObjects2016',
            'MSODBCSQL',
            'SQLNCli2008R2',
            'SQLSysClrTypes2012',
            'SharedManagementObjects2012',
            'ReportViewer2012'
            #, 'AppErrorReporting'
        )]
        [string]
        $Prerequisite,
        [string]$DynamicsPrerequisiteFilePath = "."
    )
    if ( $prerequisite )
    {
        $expectedProductIdentifyingNumber = $Dynamics365Resources.$prerequisite.IdentifyingNumber;
        $installedProducts = Get-WmiObject Win32_Product | ForEach-Object { $_.IdentifyingNumber }
        if ( $expectedProductIdentifyingNumber )
        {
            $isInstalled = $installedProducts -contains "{$expectedProductIdentifyingNumber}";
        } else {
            Write-Output "IdentifyingNumber is not specified for this product, installation verification will be skipped";
        }
        if ( !$expectedProductIdentifyingNumber -or !$isInstalled ) {
            $tempDirPath = $false;
            Write-Debug "Installing $prerequisite prerequisite"
            switch ( $prerequisite ) {
                { ( $_ -eq 'VisualCPlusPlusRuntime' ) -or ( $_ -eq 'VisualCPlusPlus2010Runtime' ) } {
                    $resourceUrl = $Dynamics365Resources.$prerequisite.URL;
                    $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
                    $defaultFileName = $matches[0];
                    $defaultDirectoryName = "$prerequisite";
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
                    $resourceUrl = $Dynamics365Resources.$prerequisite.URL;
                    $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
                    $defaultFileName = $matches[0];
                    $defaultDirectoryName = $prerequisite;
                }
            }
            $resourcePathItem = Get-Item $dynamicsPrerequisiteFilePath;
            if ( !$resourcePathItem ) { throw "Specified file or directory '$dynamicsPrerequisiteFilePath' could not be found" }
            $dynamicsPrerequisiteFilePath = ( Resolve-Path $dynamicsPrerequisiteFilePath ).Path;
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
                        Save-Dynamics365Resource -Resource $prerequisite -TargetDirectory $tempDirPath
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
            Write-Output "$(Get-Date) Starting $fullFilePath. Log will be saved in $( Resolve-Path . )\$logFile";
            switch ( $prerequisite ) {
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
                { ( $_ -eq 'SQLNCli2012SP4' ) -or ( $_ -eq 'SQLNCli2008R2' ) } {
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
            Write-Output "$(Get-Date) Finished $fullFilePath";
            if ( $tempDirPath ) {
                Remove-Item $tempDirPath -Recurse -Force
            }
            Write-Output "The following products were installed:"
            Get-WmiObject Win32_Product | ForEach-Object {
                if ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) {
                    $isInstalled = $true
                }
                if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                    Write-Output $_.IdentifyingNumber, $_.Name;
                }
            }
            if ( $expectedProductIdentifyingNumber )
            {
                if ( $isInstalled ) {
                    Write-Output "Installation is finished and verified successfully";
                } else {
                    Write-Output "Installation job finished but the product is still not installed";
                }
            } else {
                Write-Output "Installation is finished but verification cannot be done without IdentifyingNumber specified.";
            }
        } else {
            Write-Output "Product is already installed, skipping"
        }
    } else {
        Write-Output "prerequisite is not specified";
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlusRuntime -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlus2010Runtime -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite VisualCPlusPlus2010Runtime -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite SQLNCli2012SP4 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite SQLSysClrTypes2016 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite SQLSysClrTypes2016 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite SharedManagementObjects2016 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite SharedManagementObjects2016 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite MSODBCSQL -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite MSODBCSQL -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite SQLNCli2008R2 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite SQLNCli2008R2 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite SQLSysClrTypes2012 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite SQLSysClrTypes2012 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite SharedManagementObjects2012 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite SharedManagementObjects2012 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        Write-Output "Install-Dynamics365Prerequisite -Prerequisite ReportViewer2012 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath";
        Install-Dynamics365Prerequisite -Prerequisite ReportViewer2012 -DynamicsPrerequisiteFilePath $DynamicsPrerequisiteFilePath;
        #Install-Dynamics365Prerequisite -Prerequisite AppErrorReporting
    }
}
