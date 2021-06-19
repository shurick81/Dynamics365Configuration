function Install-Dynamics365ReportingExtensions {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $MediaDir,
        [string]
        $Patch,
        [string]
        $InstanceName,
        [string]
        $ConfigDBServer,
        [switch]
        $AutoGroupManagementOff,
        [switch]
        $MUOptin = $false,
        [string]
        $LogFilePath = $null,
        [ValidateRange(1,3600)]
        [int]
        $LogFilePullIntervalInSeconds = 30,
        [switch]
        $LogFilePullToOutput = $False
    )
    $AutoGroupManagementOffBool = [bool]$AutoGroupManagementOff;
    $setupFilePath = "$mediaDir\SetupSrsDataConnector.exe";
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw.ToString();
    Write-Output "Version of software to be installed: $fileVersion";
    $languageCode = ( Get-Item $mediaDir\LangPacks\* ).Name;
    Write-Output "Language code of software to be installed: $languageCode";
    $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { $Dynamics365Resources.( $_.Name ).ReportingExtensionsIdentifyingNumber } | ForEach-Object {
        if ( ( $Dynamics365Resources.( $_.Name ).MediaFileVersion -eq $fileVersion ) -and ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $languageCode ) ) { $foundFileResource = $_.Name }
    }
    $installedProducts = Get-WmiObject Win32_Product -ComputerName $env:COMPUTERNAME | ForEach-Object { $_.IdentifyingNumber }
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
            $srsDataConnectorElement = $xml.CreateElement( "srsdataconnector" );
                $configDBServerElement = $xml.CreateElement( "configdbserver" );
                    $configDBServerElement.InnerText = $configDBServer;
                $srsDataConnectorElement.AppendChild( $configDBServerElement ) | Out-Null;
                $autoGroupManagementOffElement = $xml.CreateElement( "autogroupmanagementoff" );
                    $autoGroupManagementOffElement.InnerText = [int]$AutoGroupManagementOffBool;
                $srsDataConnectorElement.AppendChild( $autoGroupManagementOffElement ) | Out-Null;
                if ( $InstanceName ) {
                    $instanceNameElement = $xml.CreateElement( "instancename" );
                        $instanceNameElement.InnerText = $InstanceName;
                    $srsDataConnectorElement.AppendChild( $instanceNameElement ) | Out-Null;
                }
                $patchElement = $xml.CreateElement( "Patch" );
                    if ( $Patch -ne $null ) {
                        $patchElement.SetAttribute( "Update", $true ) | Out-Null;
                        $patchElement.InnerText = $Patch;
                    } else {
                        $patchElement.SetAttribute( "Update", $false ) | Out-Null;
                    }
                $srsDataConnectorElement.AppendChild( $patchElement ) | Out-Null;
                $MUOptinElement = $xml.CreateElement( "muoptin" );
                    $MUOptinElement.SetAttribute( "optin", $MUOptin.ToString().ToLower() ) | Out-Null;
                $srsDataConnectorElement.AppendChild( $MUOptinElement ) | Out-Null;
            $crmSetupElement.AppendChild( $srsDataConnectorElement ) | Out-Null;
        $xml.AppendChild( $crmSetupElement ) | Out-Null;

        $stringWriter = New-Object System.IO.StringWriter;
        $xmlWriter = New-Object System.Xml.XmlTextWriter $stringWriter;
        $xmlWriter.Formatting = "indented";
        $xml.WriteTo( $xmlWriter );
        $xmlWriter.Flush();
        $stringWriter.Flush();
        $xmlConfig = $stringWriter.ToString();

        if([String]::IsNullOrEmpty($logFilePath) -eq $True) {
            $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
            $logFilePath = "$env:APPDATA\Microsoft\MSCRM\Logs\DynamicsReportingExtensionsInstallationLog_$timeStamp.txt";
        }
        $tempFileName = [guid]::NewGuid().Guid;
        $tempFilePath = "$env:Temp\$tempFileName.xml";
        Write-Output "$(Get-Date) Saving configuration temporary to $tempFilePath";
        Set-Content -Path $tempFilePath -Value $xmlConfig -Encoding utf8;
        Get-Content $tempFilePath;
        Write-Output "$(Get-Date) Starting $setupFilePath";
        $installCrmScript = {
            param( $setupFilePath, $tempFilePath, $logFilePath );
            Write-Output "Start-Process '$setupFilePath' -ArgumentList '/Q /config $tempFilePath /L $logFilePath' -Wait;";
            Start-Process "$setupFilePath" -ArgumentList "/Q /config $tempFilePath /L $logFilePath" -Wait;
        }
        $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $tempFilePath, $logFilePath;
        Write-Output "$(Get-Date) Started installation job, log will be saved in $logFilePath";
        $lastLinesCount = 0;
        $startTime = Get-Date;
        do {
            $elapsedTime = $( Get-Date ) - $startTime;
            $elapsedString = "{0:HH:mm:ss}" -f ( [datetime]$elapsedTime.Ticks );
            Write-Output "$(Get-Date) Elapsed $elapsedString. Waiting until CRM reporting extensions job is done, sleeping $logFilePullIntervalInSeconds sec";
            Start-Sleep $logFilePullIntervalInSeconds;
            $jobState = $job.State;
            if ( $logFilePullToOutput ) {
                if ( Test-Path $logFilePath ) {
                    $logFileContents = Get-Content $logFilePath -ReadCount 0;
                    $linesCount = $logFileContents.Length;
                    $newLinesCount = $linesCount - $lastLinesCount;
                    if($newLinesCount -gt 0) {
                        Write-Output "$(Get-Date) - new logs: $newLinesCount lines";
                        $logFileContents | Select-Object -First $newLinesCount -Skip $lastLinesCount | Write-Output;
                    } else {
                        Write-Output "$(Get-Date) - no new logs";
                    }
                    $lastLinesCount = $linesCount;
                }
            }
        } until ( $jobState -eq "Completed" )
        $elapsedTime = $( Get-Date ) - $startTime;
        $elapsedString = "{0:HH:mm:ss}" -f ( [datetime]$elapsedTime.Ticks );
        Write-Output "$(Get-Date) Elapsed $elapsedString. Job is complete, output:";
        Write-Output ( Receive-Job $job );
        Remove-Job $job;
        Start-Sleep 10;
        Remove-Item $tempFilePath;
        if( (Test-Path $logFilePath) -eq $True) {
            $errorLines = Get-Content $logFilePath | Select-String -Pattern "Error|" -SimpleMatch;
            if ( $errorLines ) {
                Write-Output "Errors from install log:";
                $errorLines | Foreach-Object {
                    Write-Output $_.Line;
                }
            }
        }
        Write-Output "The following products were installed:"
        Get-WmiObject Win32_Product -ComputerName $env:COMPUTERNAME | ForEach-Object {
            if ( !$expectedProductIdentifyingNumber -or ( $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" ) ) {
                $isInstalled = $true;
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
