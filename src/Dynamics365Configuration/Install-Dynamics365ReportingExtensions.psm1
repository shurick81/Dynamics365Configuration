function Install-Dynamics365ReportingExtensions {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $MediaDir,
        [Parameter(Mandatory=$true)]
        [string]
        $InstanceName,
        [string]
        $ConfigDBServer,
        [switch]
        $MUOptin = $false,
        [pscredential]
        $InstallAccount
    )
    $setupFilePath = "$mediaDir\SetupSrsDataConnector.exe";
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw.ToString();
    Write-Host "Version of software to be installed: $fileVersion";
    $languageCode = ( Get-Item $mediaDir\LangPacks\* ).Name;
    Write-Host "Language code of software to be installed: $languageCode";
    $Dynamics365Resources | Get-Member -MemberType NoteProperty | ? { $Dynamics365Resources.( $_.Name ).ReportingExtensionsIdentifyingNumber } | % {
        if ( ( $Dynamics365Resources.( $_.Name ).MediaFileVersion -eq $fileVersion ) -and ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $languageCode ) ) { $foundFileResource = $_.Name }
    }
    if ( $configDBServer ) {
        $configDBServerXmlParameter = $configDBServer;
    } else {
        $configDBServerXmlParameter = $env:COMPUTERNAME;
    }
    if ( $InstallAccount -and $configDBServer )
    {
        $installedProducts = Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter -Credential $InstallAccount | % { $_.IdentifyingNumber }
    } else {
        $installedProducts = Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter | % { $_.IdentifyingNumber }
    }
    if ( $foundFileResource )
    {
        Write-Host "Found corresponding resource in the catalog: $foundFileResource";
        $expectedProductIdentifyingNumber = $Dynamics365Resources.$foundFileResource.ReportingExtensionsIdentifyingNumber;
    } else {
        Write-Host "Corresponding resource is not found in the catalog. Installation verification will be skipped";
    }
    if ( $expectedProductIdentifyingNumber )
    {
        $isInstalled = $installedProducts -contains "{$expectedProductIdentifyingNumber}";
    } else {
        Write-Host "IdentifyingNumber is not specified for this product, installation verification will be skipped";
    }
    # Starting installation only when not installed or if id is not found in catalog.
    if ( !$expectedProductIdentifyingNumber -or !$isInstalled ) {
        $xml = [xml]"";
        $crmSetupElement = $xml.CreateElement( "CRMSetup" );
            $srsCataConnectorElement = $xml.CreateElement( "srsdataconnector" );
                $configDBServerElement = $xml.CreateElement( "configdbserver" );
                    $configDBServerElement.InnerText = "$configDBServerXmlParameter\$InstanceName";
                $srsCataConnectorElement.AppendChild( $configDBServerElement ) | Out-Null;
                $autoGroupManagementOffElement = $xml.CreateElement( "autogroupmanagementoff" );
                    $autoGroupManagementOffElement.InnerText = 0;
                $srsCataConnectorElement.AppendChild( $autoGroupManagementOffElement ) | Out-Null;
                $instanceNameElement = $xml.CreateElement( "instancename" );
                    $instanceNameElement.InnerText = $InstanceName;
                $srsCataConnectorElement.AppendChild( $instanceNameElement ) | Out-Null;
                $patchElement = $xml.CreateElement( "Patch" );
                    $patchElement.SetAttribute( "Update", $false ) | Out-Null;
                $srsCataConnectorElement.AppendChild( $patchElement ) | Out-Null;
                $MUOptinElement = $xml.CreateElement( "muoptin" );
                    $MUOptinElement.SetAttribute( "optin", $MUOptin.ToString().ToLower() ) | Out-Null;
                $srsCataConnectorElement.AppendChild( $MUOptinElement ) | Out-Null;
            $crmSetupElement.AppendChild( $srsCataConnectorElement ) | Out-Null;
        $xml.AppendChild( $crmSetupElement ) | Out-Null;

        $stringWriter = New-Object System.IO.StringWriter;
        $xmlWriter = New-Object System.Xml.XmlTextWriter $stringWriter;
        $xmlWriter.Formatting = "indented";
        $xml.WriteTo( $xmlWriter );
        $xmlWriter.Flush();
        $stringWriter.Flush();

        $localInstallationScriptBlock = {
            param( $setupFilePath, $xmlConfig )
            $tempFileName = [guid]::NewGuid().Guid;
            $tempFilePath = "$env:Temp\$tempFileName.xml";
            Write-Host "$(Get-Date) Saving configuration temporary to $tempFilePath";
            Set-Content -Path $tempFilePath -Value $xmlConfig;
            Write-Host "$(Get-Date) Starting $setupFilePath";
            $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
            $logFileName = "$env:Temp\DynamicsReportingExtensionsInstallationLog_$timeStamp.txt";
            $installCrmScript = {
                param( $setupFilePath, $tempFilePath, $logFileName );
                Write-Host "Start-Process '$setupFilePath' -ArgumentList '/Q /config $tempFilePath /L $logFileName' -Wait;";
                Start-Process "$setupFilePath" -ArgumentList "/Q /config $tempFilePath /L $logFileName" -Wait;
            }
            $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $tempFilePath, $logFileName;
            Write-Host "$(Get-Date) Started installation job, log will be saved in $logFileName";
            While ( $job.State -ne "Completed" )
            {
                Write-Host "$(Get-Date) Waiting until CRM installation job is done";
                Sleep 60;
            }
            Write-Host "$(Get-Date) Job is complete, output:";
            Write-Output ( Receive-Job $job );
            Remove-Job $job;
            Sleep 10;
            Remove-Item $tempFilePath;
        }
        if ( $installAccount )
        {
            $domainName = (Get-WmiObject Win32_ComputerSystem).Domain;
            Invoke-Command -ScriptBlock $localInstallationScriptBlock "$configDBServerXmlParameter.$domainName" -Credential $installAccount -Authentication CredSSP -ArgumentList $setupFilePath, $stringWriter.ToString();
        } else {
            Invoke-Command -ScriptBlock $localInstallationScriptBlock -ArgumentList $setupFilePath, $stringWriter.ToString();
        }
        Write-Host "The following products were installed:"
        if ( $InstallAccount -and $configDBServer )
        {
            Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter -Credential $InstallAccount | % {
                if ( !$expectedProductIdentifyingNumber -or ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) ) {
                    $isInstalled = $true;
                }
                if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                    Write-Host $_.IdentifyingNumber, $_.Name;
                }
            }
        } else {
            Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter | % {
                if ( !$expectedProductIdentifyingNumber -or ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) ) {
                    $isInstalled = $true;
                }
                if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                    Write-Host $_.IdentifyingNumber, $_.Name;
                }
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
    } else {
        Write-Host "Product is already installed, skipping"
    }
}
