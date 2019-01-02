function Install-Dynamics365Update {
    param (
        [parameter(Position=0,
        Mandatory=$true)]
        [string]
        $MediaDir,
        [pscredential]
        $InstallAccount
    )
    $localInstallationScriptBlock = {
        param( $mediaDir )
        Write-Host "$(Get-Date) Starting $mediaDir\crmupdatewrapper.exe";
        $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
        $logFileName = "$env:Temp\CRMUpdateInstallationLog_$timeStamp.txt";
        $installCrmScript = {
            param( $mediaDir, $logFileName );
            Write-Host "Start-Process '$mediaDir\crmupdatewrapper.exe' -ArgumentList '/q /log $logFileName /norestart' -Wait;";
            Start-Process "$mediaDir\crmupdatewrapper.exe" -ArgumentList "/q /log $logFileName /norestart" -Wait;
        }
        $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $mediaDir, $logFileName;
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
        Invoke-Command -ScriptBlock $localInstallationScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP -ArgumentList $mediaDir;
    } else {
        Invoke-Command -ScriptBlock $localInstallationScriptBlock -ArgumentList $mediaDir;
    }
}

