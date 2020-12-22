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
    $fileVersion = [version]( Get-Command $setupFilePath ).FileVersionInfo.FileVersion;
    Write-Output "Version of software to be installed: $($fileVersion.ToString())";
    $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -Name CRM_SrsDataConnector_Serviceability_Version -ErrorAction Ignore;
    if ( !$msCRMRegistryValues ) {
        $errorMessage = "Dynamics 365 Server for Customer Engagement Reporting Extensions are not installed on this machine";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    $installedVersion = Get-Dynamics365ReportingExtensionsVersion;
    Write-Output "Currently installed: $($installedVersion.ToString())";
    if ( $fileVersion.Major -ne $installedVersion.Major ) {
        $errorMessage = "Major version of this update does not correspond to major version of installed software";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    if ( $fileVersion -lt $installedVersion ) {
        $errorMessage = "Version of this update is lower than version of installed software";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    if ( $fileVersion -eq $installedVersion ) {
        Write-Output "This version is already installed";
        return;
    }
    if ([String]::IsNullOrEmpty($logFilePath) -eq $True) {
        $timeStamp = ( Get-Date -Format u ).Replace(" ", "-").Replace(":", "-");
        $logFilePath = "$env:Temp\DynamicsReportingExtensionsUpdateInstallationLog_$timeStamp.txt";
    }

    Write-Output "$(Get-Date) Version of software to be installed: $fileVersion";

    Write-Output "Checking the msp file name"
    $reportingExtensionsUpdateMspFile = Get-Item "$mediaDir\Srs_KB???????_amd64_????.msp";
    if ( $reportingExtensionsUpdateMspFile ) {
        Write-Output "The update seems to correspond to Reporting Extensions";
        $installedLanguageCode = ( Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -Name CRM_SrsDataConnector_LanguageID ).CRM_SrsDataConnector_LanguageID;
        if ( $reportingExtensionsUpdateMspFile.BaseName.Substring(20,4) -ne $installedLanguageCode ) {
            $errorMessage = "Language of the update does not correspond to the language of the installed base product";
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
            $startTime = Get-Date;
            Start-Sleep $logFilePullIntervalInSeconds;
            do {
                $elapsedTime = $( Get-Date ) - $startTime;
                $elapsedString = "{0:HH:mm:ss}" -f ( [datetime]$elapsedTime.Ticks );
                Write-Output "$(Get-Date) Elapsed $elapsedString. Waiting until CRM reporting extensions update installation job is done, sleeping $logFilePullIntervalInSeconds sec";
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
            } until ( $job.State -eq "Completed" )

            $elapsedTime = $( Get-Date ) - $startTime;
            $elapsedString = "{0:HH:mm:ss}" -f ( [datetime]$elapsedTime.Ticks );
            Write-Output "$(Get-Date) Elapsed $elapsedString. Job is complete, output:";
            Write-Output ( Receive-Job $job );
            Remove-Job $job;
        }
        Invoke-Command -ScriptBlock $localInstallationScriptBlock `
            -ArgumentList $setupFilePath, $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput;
        $installedVersion = Get-Dynamics365ReportingExtensionsVersion;
        Write-Output "The following version of the product is currently installed: $installedVersion"
        if ( $installedVersion -ne $fileVersion ) {
            $errorMessage = "Installed version of the product is not the same as the version of the file resource specified";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        Write-Output "Reporting Extensions Update file is not found";
    }
}

