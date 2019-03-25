function Install-Dynamics365ReportingExtensionsUpdate {
    param (
        [parameter(Position = 0,
            Mandatory = $true)]
        [string]
        $MediaDir,
        [string]
        $LogFilePath = $null,
        [ValidateRange(1, 3600)]
        [int]
        $LogFilePullIntervalInSeconds = 30,
        [switch]
        $LogFilePullToOutput = $False
    )
    $setupFilePath = "$mediaDir\CrmUpdateWrapper.exe";
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw;
    $fileVersionFull = "$($fileVersion.Major).$($fileVersion.Minor).$($fileVersion.Build.ToString("0000")).$($fileVersion.Revision.ToString("0000"))";
    Write-Output "$(Get-Date) Version of software to be installed: $fileVersionFull";

    Write-Host "Checking the msp file name"
    $reportingExtensionsUpdateMspFile = Get-Item "$mediaDir\Srs_KB???????_amd64_????.msp";
    if ( $reportingExtensionsUpdateMspFile ) {
        Write-Output "The update seems to correspond to Reporting Extensions";
        Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | ForEach-Object {
            $pSChildName = $_.PSChildName;
            $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { ( $_.Name -like "Dynamics365Server90RTM*" ) -or ( $_.Name -like "CRM2016RTM*" ) } | ForEach-Object {
                if ( "{$( $Dynamics365Resources.( $_.Name ).reportingExtensionsIdentifyingNumber )}" -eq $pSChildName ) {
                    $baseResource = $_.Name;
                    $languageCode = $Dynamics365Resources.$baseResource.LanguageCode;
                    Write-Output "Found corresponding base resource in the catalog: $baseResource";
                    if ( $reportingExtensionsUpdateMspFile.BaseName.Substring(20,4) -ne $languageCode ) {
                        $errorMessage = "Language of the update does not correspond to the language of the installed base product";
                        Write-Output $errorMessage;
                        Throw $errorMessage;
                    }
                    $currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "MSCRM SRS Data Connector" }
                    Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
                    if ( $currentProductInstalled.DisplayVersion -gt $fileVersionFull ) {
                        $errorMessage = "Installed version of the product is higher than the version of the file resource specified";
                        Write-Output $errorMessage;
                        Throw $errorMessage;
                    }
                }
            }
        }
        if ( !$baseResource ) {
            $errorMessage = "Base product for this update is not installed";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
        $localInstallationScriptBlock = {
            param( $setupFilePath, $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput)
            Write-Output "$(Get-Date) Starting $setupFilePath";
            $installCrmScript = {
                param( $setupFilePath, $logFilePath );
                Write-Output "Start-Process '$setupFilePath' -ArgumentList '/q /log $logFilePath /norestart' -Wait;";
                Start-Process "$setupFilePath" -ArgumentList "/q /log $logFilePath /norestart" -Wait;
            }
            $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $logFilePath;
            Write-Output "$(Get-Date) Started installation job, log will be saved in $logFilePath";
            $lastLinesCount = 0;

            While ( $job.State -ne "Completed" ) {
                Write-Output "$(Get-Date) Waiting until CRM installation job is done, sleeping $logFilePullIntervalInSeconds sec";
                Start-Sleep $logFilePullIntervalInSeconds;
                if (($logFilePullToOutput -eq $True) -and ((Test-Path $logFilePath) -eq $True)) {

                    $linesCount = (Get-Content $logFilePath | Measure-Object -Line).Lines;
                    $newLinesCount = $linesCount - $lastLinesCount;

                    if ($newLinesCount -gt 0) {
                        Write-Output "$(Get-Date) - new logs: $newLinesCount lines";
                        $lines = Get-Content $logFilePath | Select-Object -First $newLinesCount -Skip $lastLinesCount;

                        foreach ($line in $lines) {
                            Write-Output $line;
                        }
                    }
                    else {
                        Write-Output "$(Get-Date) - no new logs";
                    }

                    $lastLinesCount = $linesCount;
                }
            }

            Write-Output "$(Get-Date) Job is complete, output:";
            Write-Output ( Receive-Job $job );
            Remove-Job $job;
        }
        if ([String]::IsNullOrEmpty($logFilePath) -eq $True) {
            $timeStamp = ( Get-Date -Format u ).Replace(" ", "-").Replace(":", "-");
            $logFilePath = "$env:Temp\DynamicsReportingExtensionsInstallationLog_$timeStamp.txt";
        }
        Invoke-Command -ScriptBlock $localInstallationScriptBlock `
            -ArgumentList $setupFilePath, $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput;
        $currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "MSCRM SRS Data Connector" }
        Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
        if ( $currentProductInstalled.DisplayVersion -ne $fileVersionFull ) {
            $errorMessage = "Installed version of the product is not the same as the version of the file resource specified";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        Write-Output "Reporting Extensions Update file is not found";
    }
}

