function Install-Dynamics365Update {
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
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw.ToString();
    Write-Output "Version of software to be installed: $fileVersion";
    $testResponse = $null;
    try {
        Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
        if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
            $CrmOrganization = Get-CrmOrganization;
            $testResponse = $CrmOrganization.Version;
        } else {
            "Could not load Microsoft.Crm.PowerShell PSSnapin";
        }
    } catch {
        $_.Exception.Message;
    }
    $productDetected = $null;
    if ( $testResponse.StartsWith( "9." ) -or $testResponse.StartsWith( "8." ) ) {
        $productDetected = $testResponse;
    }
    if ( $productDetected -and ( $productDetected -lt $fileVersion ) -and ( $productDetected.Substring( 0, 2 ) -eq $fileVersion.Substring( 0, 2 ) ) ) {
        $localInstallationScriptBlock = {
            param( $setupFilePath, $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput)
        }
        if([String]::IsNullOrEmpty($logFilePath) -eq $True) {
            $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
            $logFilePath = "$env:Temp\DynamicsReportingExtensionsInstallationLog_$timeStamp.txt";
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

        $testResponse = $null;
        try {
            Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
            if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
                $CrmOrganization = Get-CrmOrganization;
                $testResponse = $CrmOrganization.Version;
            } else {
                "Could not load Microsoft.Crm.PowerShell PSSnapin";
            }
        } catch {
            $_.Exception.Message;
        }

        if ( $testResponse -eq $fileVersion ) {
            Write-Output "Installation is finished and verified successfully. Dynamics version installed: '$testResponse'";
        } else {
            if( (Test-Path $logFilePath) -eq $True) {
                $errorLines = Get-Content $logFilePath | Select-String -Pattern "Error" -SimpleMatch;

                if($null -ne $errorLines) {
                    "Errors from install log: $logFilePath";

                    foreach($errorLine in $errorLines) {
                        $errorLine;
                    }
                }
            }
            $errorMessage = "Installation job finished but the product is still not installed. Current product version installed is '$testResponse'";

            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        Write-Output "Required product is not installed, skipping the upgrade. Current Dynamics version installed: '$testResponse'";
    }
}

