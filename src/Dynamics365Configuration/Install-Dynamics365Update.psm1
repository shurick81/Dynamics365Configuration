﻿function Install-Dynamics365Update {
    param (
        [parameter(Position=0,
        Mandatory=$true)]
        [string]
        $MediaDir,
        [string]
        $LogFilePath = $null,
        [ValidateRange(1,3600)]
        [int]
        $LogFilePullIntervalInSeconds = 30,
        [switch]
        $LogFilePullToOutput = $False
    )
    $setupFilePath = "$mediaDir\CrmUpdateWrapper.exe";
    $fileVersion = [version]( Get-Command $setupFilePath ).FileVersionInfo.FileVersion;
    Write-Output "Version of software to be installed: $($fileVersion.ToString())";
    $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
    if ( !$msCRMRegistryValues ) {
        $errorMessage = "Dynamics 365 Server for Customer Engagement is not installed on this machine";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    $installedVersion = Get-Dynamics365ServerVersion;
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
    if([String]::IsNullOrEmpty($logFilePath) -eq $True) {
        $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
        $logFilePath = "$env:APPDATA\Microsoft\MSCRM\Logs\DynamicsUpdateInstallationLog_$timeStamp.txt";
    }

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
    do {
        $elapsedTime = $( Get-Date ) - $startTime;
        $elapsedString = "{0:HH:mm:ss}" -f ( [datetime]$elapsedTime.Ticks );
        Write-Output "$(Get-Date) Elapsed $elapsedString. Waiting until CRM update installation job is done, sleeping $logFilePullIntervalInSeconds sec";
        Start-Sleep $logFilePullIntervalInSeconds;
        $jobState = $job.State;
        if ( $logFilePullToOutput ) {
            if ( Test-Path $logFilePath ) {
                $logFileContents = Get-Content $logFilePath;
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
    if( (Test-Path $logFilePath) -eq $True) {
        $errorLines = Get-Content $logFilePath | Select-String -Pattern "Error|" -SimpleMatch;
        if ( $errorLines ) {
            Write-Output "Errors from install log:";
            $errorLines | Foreach-Object {
                Write-Output $_.Line;
            }
        }
    }
    $installedVersion = Get-Dynamics365ServerVersion;
    Write-Output "Currently installed: $($installedVersion.ToString())";
    if ( $fileVersion -ne $installedVersion ) {
        $errorMessage = "Version of installed software is not the same as installed update";
        Write-Output $errorMessage;
        Throw $errorMessage;
    } else {
        Write-Output "Installation is finished and verified successfully";
    }
}
