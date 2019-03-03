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
        $InstallAccount,
        [string]
        $LogFilePath = $null,
        [ValidateRange(1,3600)]
        [int]
        $LogFilePullIntervalInSeconds = 30,
        [switch]
        $LogFilePullToOutput = $False
    )
    $setupFilePath = "$mediaDir\SetupSrsDataConnector.exe";
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw.ToString();
    Write-Output "Version of software to be installed: $fileVersion";
    $languageCode = ( Get-Item $mediaDir\LangPacks\* ).Name;
    Write-Output "Language code of software to be installed: $languageCode";
    $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { $Dynamics365Resources.( $_.Name ).ReportingExtensionsIdentifyingNumber } | ForEach-Object {
        if ( ( $Dynamics365Resources.( $_.Name ).MediaFileVersion -eq $fileVersion ) -and ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $languageCode ) ) { $foundFileResource = $_.Name }
    }
    if ( $configDBServer ) {
        $configDBServerXmlParameter = $configDBServer;
    } else {
        $configDBServerXmlParameter = $env:COMPUTERNAME;
    }
    if ( $InstallAccount -and $configDBServer )
    {
        $installedProducts = Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter -Credential $InstallAccount | ForEach-Object { $_.IdentifyingNumber }
    } else {
        $installedProducts = Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter | ForEach-Object { $_.IdentifyingNumber }
    }
    if ( $foundFileResource )
    {
        Write-Output "Found corresponding resource in the catalog: $foundFileResource";
        $expectedProductIdentifyingNumber = $Dynamics365Resources.$foundFileResource.ReportingExtensionsIdentifyingNumber;
    } else {
        Write-Output "Corresponding resource is not found in the catalog. Installation verification will be skipped";
    }
    if ( $expectedProductIdentifyingNumber )
    {
        $isInstalled = $installedProducts -contains "{$expectedProductIdentifyingNumber}";
    } else {
        Write-Output "IdentifyingNumber is not specified for this product, installation verification will be skipped";
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
            param( $setupFilePath, $xmlConfig, $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput)
            $tempFileName = [guid]::NewGuid().Guid;
            $tempFilePath = "$env:Temp\$tempFileName.xml";
            Write-Output "$(Get-Date) Saving configuration temporary to $tempFilePath";
            Set-Content -Path $tempFilePath -Value $xmlConfig;
            Write-Output "$(Get-Date) Starting $setupFilePath";
            $installCrmScript = {
                param( $setupFilePath, $tempFilePath, $logFilePath );
                Write-Output "Start-Process '$setupFilePath' -ArgumentList '/Q /config $tempFilePath /L $logFilePath' -Wait;";
                Start-Process "$setupFilePath" -ArgumentList "/Q /config $tempFilePath /L $logFilePath" -Wait;
            }
            $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $tempFilePath, $logFilePath;
            Write-Output "$(Get-Date) Started installation job, log will be saved in $logFilePath";
            $lastLinesCount = 0;

            While ( $job.State -ne "Completed" )
            {
                Write-Output "$(Get-Date) Waiting until CRM installation job is done, sleeping $logFilePullIntervalInSeconds sec";
                Start-Sleep $logFilePullIntervalInSeconds;
                if(($logFilePullToOutput -eq $True) -and ((Test-Path $logFilePath) -eq $True)) {

                    $linesCount    = (Get-Content $logFilePath | Measure-Object -Line).Lines;
                    $newLinesCount = $linesCount - $lastLinesCount;

                    if($newLinesCount -gt 0) {
                        Write-Output "$(Get-Date) - new logs: $newLinesCount lines";
                        $lines = Get-Content $logFilePath | Select-Object -First $newLinesCount -Skip $lastLinesCount;

                        foreach($line in $lines) {
                            Write-Output $line;
                        }
                    } else {
                       Write-Output "$(Get-Date) - no new logs";
                    }

                    $lastLinesCount = $linesCount;
                }
            }
            Write-Output "$(Get-Date) Job is complete, output:";
            Write-Output ( Receive-Job $job );
            Remove-Job $job;
            Start-Sleep 10;
            Remove-Item $tempFilePath;
        }
        if([String]::IsNullOrEmpty($logFilePath) -eq $True) {
            $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
            $logFilePath = "$env:Temp\DynamicsReportingExtensionsInstallationLog_$timeStamp.txt";
        }
        if ( $installAccount )
        {
            $domainName = (Get-WmiObject Win32_ComputerSystem).Domain;
            Invoke-Command -ScriptBlock $localInstallationScriptBlock `
                -ComputerName "$configDBServerXmlParameter.$domainName" `
                -Credential $installAccount `
                -Authentication CredSSP `
                -ArgumentList $setupFilePath, $stringWriter.ToString(), $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput;
        } else {
            Invoke-Command -ScriptBlock $localInstallationScriptBlock `
                -ArgumentList $setupFilePath, $stringWriter.ToString(), $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput;
        }
        Write-Output "The following products were installed:"
        if ( $InstallAccount -and $configDBServer )
        {
            Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter -Credential $InstallAccount | ForEach-Object {
                if ( !$expectedProductIdentifyingNumber -or ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) ) {
                    $isInstalled = $true;
                }
                if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                    Write-Output $_.IdentifyingNumber, $_.Name;
                }
            }
        } else {
            Get-WmiObject Win32_Product -ComputerName $configDBServerXmlParameter | ForEach-Object {
                if ( !$expectedProductIdentifyingNumber -or ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) ) {
                    $isInstalled = $true;
                }
                if ( !( $installedProducts -contains $_.IdentifyingNumber ) ) {
                    Write-Output $_.IdentifyingNumber, $_.Name;
                }
            }
        }
        if ( $expectedProductIdentifyingNumber )
        {
            if ( $isInstalled ) {
                Write-Output "Installation is finished and verified successfully";
            } else {
                $getErrorLogScriptBlock = {
                    param( $logFilePath )
                    if( (Test-Path $logFilePath) -eq $True) {
                        $errorLines = Get-Content $logFilePath | Select-String -Pattern "Error" -SimpleMatch;

                        if($null -ne $errorLines) {
                            "Errors from install log: $logFilePath";

                            foreach($errorLine in $errorLines) {
                                $errorLine;
                            }
                        }
                    }
                }
                if ( $installAccount )
                {
                    Invoke-Command -ScriptBlock $getErrorLogScriptBlock `
                        -ComputerName "$configDBServerXmlParameter.$domainName" `
                        -Credential $installAccount `
                        -Authentication CredSSP `
                        -ArgumentList $logFilePath
                } else {
                    Invoke-Command -ScriptBlock $getErrorLogScriptBlock `
                        -ArgumentList $logFilePath
                }
                $errorMessage = "Installation job finished but the product $expectedProductIdentifyingNumber is still not installed";

                Write-Output $errorMessage;
                Throw $errorMessage;
            }
        } else {
            Write-Output "Installation is finished but verification cannot be done without IdentifyingNumber specified.";
        }
    } else {
        Write-Output "Product is already installed, skipping";
    }
}
