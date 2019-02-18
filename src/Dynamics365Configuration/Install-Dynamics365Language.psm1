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
        $languageCode = $msiFile.Name.Substring( 9, 4 );
        $installedProducts = Get-WmiObject Win32_Product | ForEach-Object { $_.IdentifyingNumber }
        $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { $_.Name.StartsWith( "Dynamics365Server90RTM" ) } | ForEach-Object {
            if ( $installedProducts -contains "{$( $Dynamics365Resources.( $_.Name ).IdentifyingNumber )}" ) {
                Write-Output "$(Get-Date) Detected Dynamics 9.X installed";
                $fileResourceNamePrefix = "Dynamics365Server90LanguagePack";
            }
        }
        if ( !$fileResourceNamePrefix ) {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { $_.Name.StartsWith( "CRM2016RTM" ) } | ForEach-Object {
                if ( $installedProducts -contains "{$( $Dynamics365Resources.( $_.Name ).IdentifyingNumber )}" ) {
                    Write-Output "$(Get-Date) Detected Dynamics 8.X installed";
                    $fileResourceNamePrefix = "CRM2016LanguagePack";
                }
            }
        }
        if ( !$fileResourceNamePrefix ) {
            Write-Output "Dynamics is not detected";
        }
        $foundFileResource = $null;
        if ( $fileResourceNamePrefix ) {
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { $_.Name.StartsWith( $fileResourceNamePrefix ) } | ForEach-Object {
                if ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $languageCode ) { $foundFileResource = $_.Name }
            }
        }
        if ( $foundFileResource )
        {
            Write-Output "Found corresponding resource in the catalog: $foundFileResource";
            $expectedProductIdentifyingNumber = $Dynamics365Resources.$foundFileResource.IdentifyingNumber;
        } else {
            Write-Output "Corresponding resource is not found in the catalog. Installation verification will be skipped";
        }
        if ( $expectedProductIdentifyingNumber )
        {
            $isInstalled = $installedProducts -contains "{$expectedProductIdentifyingNumber}";
        } else {
            Write-Output "IdentifyingNumber is not specified for this product, installation verification will be skipped";
        }
        if ( !$expectedProductIdentifyingNumber -or !$isInstalled ) {
            $isInstalled = $false;
            $retries = 20;
            While ( !$isInstalled -and $retries -gt 0 )
            {
                Write-Output "$(Get-Date) Starting $msiFullName, retries left: $retries";
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
                Write-Output "$(Get-Date) Finished $msiFullName";
                Write-Output "The following products were installed:";
                Get-WmiObject Win32_Product | ForEach-Object {
                    if ( !$expectedProductIdentifyingNumber -or ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) ) {
                        $isInstalled = $true;
                    }
                    if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                        Write-Output $_.IdentifyingNumber, $_.Name;
                    }
                }
                $retries--;
                Start-Sleep 10;
            }
            if ( $expectedProductIdentifyingNumber )
            {
                if ( $isInstalled ) {
                    Write-Output "Installation is finished and verified successfully";
                } else {
                    Write-Output "Installation job finished but the product is still not installed";
                    Throw "Installation job finished but the product is still not installed";
                }
            } else {
                Write-Output "Installation is finished but verification cannot be done without IdentifyingNumber specified.";
            }
        } else {
            Write-Output "Product is already installed, skipping"
        }
    } else {
        Write-Output "$(Get-Date) No or too many $mediaDir\MuiSetup_????_amd64.msi files were found";
    }
}

