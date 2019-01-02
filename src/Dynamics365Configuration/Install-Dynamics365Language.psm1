function Install-Dynamics365Language {
    param (
        [parameter(Position=0,
        Mandatory=$true)]
        [string]
        $MediaDir
    )
    $msiFile = Get-ChildItem "$mediaDir\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -eq 1 )
    {
        $msiFullName = $msiFile.FullName;
        Write-Host "$(Get-Date) Starting $msiFullName";

        $logFile = '{0}-{1}.log' -f $msiFile.Name, $DataStamp;
        $MSIArguments = @(
            "/i"
            ( '"{0}"' -f $msiFullName )
            "/qn"
            "/norestart"
            "/L*v"
            $logFile
        )
        Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow;
        Write-Host "$(Get-Date) Finished $msiFullName";
    } else {
        Write-Host "$(Get-Date) No or too many $mediaDir\MuiSetup_????_amd64.msi files were found";
    }
}

