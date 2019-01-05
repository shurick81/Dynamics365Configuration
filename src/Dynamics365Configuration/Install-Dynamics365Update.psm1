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
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersion;
    $foundFileResource = $null;
    $Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
        if ( $Dynamics365Resources.( $_.Name ).MediaFileVersion -eq $fileVersion ) { $foundFileResource = $_.Name }
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
        $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" }
    } else {
        Write-Host "IdentifyingNumber is not specified for this product, installation verification will be skipped";
    }
    if ( !$expectedProductIdentifyingNumber -or !$installedProduct )
    {
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
        if ( $expectedProductIdentifyingNumber )
        {
            $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{$expectedProductIdentifyingNumber}" }
            if ( $installedProduct ) {
                Write-Host "Installation is finished successfully";
            } else {
                throw "Installation job finished but the product is still not installed";
            }
        } else {
            Write-Host "Installation is finished but verification cannot be done without IdentifyingNumber specified. Here is the list of all the installed products:";
            Get-WmiObject Win32_Product | Select Name, IdentifyingNumber | % {
                Write-Host $_.IdentifyingNumber, $_.Name;
            }
        }
    }
}

