function Install-Dynamics365Update {
    param (
        [parameter(Position=0,
        Mandatory=$true)]
        [string]
        $MediaDir,
        [pscredential]
        $InstallAccount
    )
    $setupFilePath = "$mediaDir\CrmUpdateWrapper.exe";
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw.ToString();
    Write-Host "Version of software to be installed: $fileVersion";
    $testScriptBlock = {
        try {
            Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
            if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
                $CrmOrganization = Get-CrmOrganization;
                $CrmOrganization.Version;
            } else {
                "Could not load Microsoft.Crm.PowerShell PSSnapin";
            }
        } catch {
            $_.Exception.Message;
        }
    }
    if ( $installAccount )
    {
        $testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP;
    } else {
        $testResponse = Invoke-Command -ScriptBlock $testScriptBlock;
    }
    $productDetected = $null;
    if ( $testResponse.StartsWith( "9." ) -or $testResponse.StartsWith( "8." ) ) {
        $productDetected = $testResponse;
    }
    if ( $productDetected -and ( $productDetected -lt $fileVersion ) -and ( $productDetected.Substring( 0, 2 ) -eq $fileVersion.Substring( 0, 2 ) ) ) {
        $localInstallationScriptBlock = {
            param( $setupFilePath )
            Write-Host "$(Get-Date) Starting $setupFilePath";
            $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
            $logFileName = "$env:Temp\CRMUpdateInstallationLog_$timeStamp.txt";
            $installCrmScript = {
                param( $setupFilePath, $logFileName );
                Write-Host "Start-Process '$setupFilePath' -ArgumentList '/q /log $logFileName /norestart' -Wait;";
                Start-Process "$setupFilePath" -ArgumentList "/q /log $logFileName /norestart" -Wait;
            }
            $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $logFileName;
            Write-Host "$(Get-Date) Started installation job, log will be saved in $logFileName";
            While ( $job.State -ne "Completed" )
            {
                Write-Host "$(Get-Date) Waiting until CRM update installation job is done";
                Sleep 60;
            }
            Write-Host "$(Get-Date) Job is complete, output:";
            Write-Output ( Receive-Job $job );
            Remove-Job $job;
        }
        if ( $installAccount )
        {
            Invoke-Command -ScriptBlock $localInstallationScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP -ArgumentList $setupFilePath;
        } else {
            Invoke-Command -ScriptBlock $localInstallationScriptBlock -ArgumentList $setupFilePath;
        }
        $testScriptBlock = {
            try {
                Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
                if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
                    $CrmOrganization = Get-CrmOrganization;
                    $CrmOrganization.Version;
                } else {
                    "Could not load Microsoft.Crm.PowerShell PSSnapin";
                }
            } catch {
                $_.Exception.Message;
            }
        }
        if ( $installAccount )
        {
            $testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP;
        } else {
            $testResponse = Invoke-Command -ScriptBlock $testScriptBlock;
        }
        if ( $testResponse -eq $fileVersion ) {
            Write-Host "Installation is finished and verified successfully. Dynamics version installed: '$testResponse'";
        } else {
            Write-Host "Installation job finished but the product is still not installed. Current Dynamics version installed: '$testResponse'";
            Throw "Installation job finished but the product is still not installed. Current Dynamics version installed: '$testResponse'";
        }
    } else {
        Write-Host "Required product is not installed, skipping the upgrade. Current Dynamics version installed: '$testResponse'"
    }
}

