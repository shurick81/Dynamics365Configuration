function Install-Dynamics365LanguageUpdate {
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
    $languagePackUpdateMspFile = Get-Item "$mediaDir\Mui_KB???????_amd64_????.msp";
    $fileLanguageCode = $languagePackUpdateMspFile.BaseName.Substring(20,4);
    if ( !$languagePackUpdateMspFile ) {
        $errorMessage = "The update does not seem to correspond to a language pack";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    Write-Output "The update seems to correspond to a language pack";
    if ( $fileVersionFull.StartsWith( "9." ) ) {
        $fileResourceNamePrefix = "Dynamics365Server90LanguagePack";
        $baseResource = $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { ( $_.Name -like "$( $fileResourceNamePrefix )???" ) -and ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $fileLanguageCode ) }
    }
    if ( $fileVersionFull.StartsWith( "8." ) ) {
        $fileResourceNamePrefix = "CRM2016LanguagePack";
        $baseResource = $Dynamics365Resources | Get-Member -MemberType NoteProperty | Where-Object { ( $_.Name -like "$( $fileResourceNamePrefix )???" ) -and ( $Dynamics365Resources.( $_.Name ).LanguageCode -eq $fileLanguageCode ) }
    }
    if ( !$baseResource ) {
        $errorMessage = "Base product for this update is not found in the catalog";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    $baseResourceName = $baseResource.Name; 
    Write-Host "Base resource installed: $baseResourceName"
    $currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{$( $Dynamics365Resources.( $baseResourceName ).identifyingNumber )}" }
    if ( !$currentProductInstalled ) {
        $errorMessage = "Base product for this update is not installed";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )"
    if ( $currentProductInstalled.DisplayVersion -gt ( Get-Command $setupFilePath ).FileVersionInfo.ProductVersion ) {
        $errorMessage = "Installed version of the product is higher than the version of the file resource specified";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
    if ([String]::IsNullOrEmpty($logFilePath) -eq $True) {
        $timeStamp = ( Get-Date -Format u ).Replace(" ", "-").Replace(":", "-");
        $logFilePath = "$env:Temp\DynamicsLanguagePackUpdateInstallationLog_$timeStamp.txt";
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
    $currentProductInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.PSChildName -eq "{$( $Dynamics365Resources.( $baseResourceName ).identifyingNumber )}" }
    Write-Output "The following version of the product is currently installed: $( $currentProductInstalled.DisplayVersion )";
    if ( $currentProductInstalled.DisplayVersion -ne $fileVersionFull ) {
        $errorMessage = "Installed version of the product is not the same as the version of the file resource specified";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
}

