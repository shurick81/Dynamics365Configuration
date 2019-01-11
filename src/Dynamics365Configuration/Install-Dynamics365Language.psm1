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
        $installedProducts = Get-WmiObject Win32_Product | % { $_.IdentifyingNumber }
        if ( $installedProducts -contains "{$( $Dynamics365Resources.Dynamics365Server90.IdentifyingNumber )}" )
        {
            Write-Host "$(Get-Date) Detected Dynamics 9.X installed";
            $fileResourceNamePrefix = "Dynamics365Server90LanguagePack";
        }
        if ( $installedProducts -contains "{$( $Dynamics365Resources.CRM2016.IdentifyingNumber )}" )
        {
            Write-Host "$(Get-Date) Detected Dynamics 8.X installed";
            $fileResourceNamePrefix = "CRM2016LanguagePack";
        }
        $foundFileResource = $null;
        $Dynamics365Resources | Get-Member -MemberType NoteProperty | ? { $_.Name.StartsWith( $fileResourceNamePrefix ) } | % {
            if ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $languageCode ) { $foundFileResource = $_.Name }
        }
        if ( $foundFileResource )
        {
            Write-Host "Found corresponding resource in the catalog: $foundFileResource";
            $expectedProductIdentifyingNumber = $Dynamics365Resources.$foundFileResource.IdentifyingNumber;
        } else {
            Write-Host "Corresponding resource is not found in the catalog. Installation verification will be skipped";
        }
        if ( $expectedProductIdentifyingNumber )
        {
            $isInstalled = $installedProducts -contains "{$expectedProductIdentifyingNumber}";
        } else {
            Write-Host "IdentifyingNumber is not specified for this product, installation verification will be skipped";
        }
        if ( !$expectedProductIdentifyingNumber -or !$isInstalled ) {
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
            Write-Host "$(Get-Date) Finished $msiFullName";
            $isInstalled = $false;
            $retries = 20;
            While ( !$isInstalled -and $retries -gt 0 )
            {
                Write-Host "$(Get-Date) Verifying product installation, retries left: $retries"
                Write-Host "The following products were installed:"
                Get-WmiObject Win32_Product | % {
                    if ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) {
                        $isInstalled = $true;
                    }
                    if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                        Write-Host $_.IdentifyingNumber, $_.Name;
                    }
                }
                if ( $expectedProductIdentifyingNumber )
                {
                    if ( $isInstalled ) {
                        Write-Host "Installation is finished and verified successfully";
                    } else {
                        Write-Host "Installation job finished but the product is still not installed";
                        Throw "Installation job finished but the product is still not installed";
                    }
                } else {
                    Write-Host "Installation is finished but verification cannot be done without IdentifyingNumber specified.";
                }
                $retries--;
                Sleep 10;
            }
        } else {
            Write-Host "Product is already installed, skipping"
        }
    } else {
        Write-Host "$(Get-Date) No or too many $mediaDir\MuiSetup_????_amd64.msi files were found";
    }
}

