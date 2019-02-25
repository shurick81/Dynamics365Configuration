try {
    $currentProgressPreference = $ProgressPreference;
    $ProgressPreference = 'SilentlyContinue';
    Write-Output "$(Get-Date) Downloading https://download.microsoft.com/download/4/3/4/434A4C02-8834-4A1B-AC55-D05F4CDEEE45/CRM2016-Mui-ENU-amd64.exe to .\CRM2016-Mui-ENU-amd64.exe";
    Invoke-WebRequest -Uri "https://download.microsoft.com/download/4/3/4/434A4C02-8834-4A1B-AC55-D05F4CDEEE45/CRM2016-Mui-ENU-amd64.exe" -OutFile .\CRM2016-Mui-ENU-amd64.exe;
    Write-Output "$(Get-Date) Downloading https://download.microsoft.com/download/4/3/4/434A4C02-8834-4A1B-AC55-D05F4CDEEE45/CRM2016-Mui-SAU-amd64.exe to .\CRM2016-Mui-SAU-amd64.exe";
    Invoke-WebRequest -Uri "https://download.microsoft.com/download/6/9/1/6917A5FC-7C6A-47CD-A480-885476216DB5/CRM2016-Mui-SAU-amd64.exe" -OutFile .\CRM2016-Mui-SAU-amd64.exe;
    $ProgressPreference = $currentProgressPreference;
    Expand-Dynamics365Resource;
    $msiFile = Get-ChildItem ".\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -ge 1 ) {
        Write-Output "File .\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi found";
    } else {
        Write-Output "File .\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi not found";
        Exit 1;
    }
    $msiFile = Get-ChildItem ".\CRM2016-Mui-SAU-amd64\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -ge 1 ) {
        Write-Output "File .\CRM2016-Mui-SAU-amd64\MuiSetup_????_amd64.msi found";
    } else {
        Write-Output "File .\CRM2016-Mui-SAU-amd64\MuiSetup_????_amd64.msi not found";
        Exit 1;
    }
    Remove-Item .\CRM2016-Mui-ENU-amd64 -Recurse -Force;
    Expand-Dynamics365Resource .\CRM2016-Mui-ENU-amd64.exe;
    $msiFile = Get-ChildItem ".\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -ge 1 ) {
        Write-Output "File .\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi found";
    } else {
        Write-Output "File .\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi not found";
        Exit 1;
    }
    Expand-Dynamics365Resource -TargetDirectory C:\Install\Dynamics;
    $msiFile = Get-ChildItem "C:\Install\Dynamics\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -ge 1 ) {
        Write-Output "File C:\Install\Dynamics\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi found";
    } else {
        Write-Output "File C:\Install\Dynamics\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi not found";
        Exit 1;
    }
    $msiFile = Get-ChildItem "C:\Install\Dynamics\CRM2016-Mui-SAU-amd64\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -ge 1 ) {
        Write-Output "File C:\Install\Dynamics\CRM2016-Mui-SAU-amd64\MuiSetup_????_amd64.msi found";
    } else {
        Write-Output "File C:\Install\Dynamics\CRM2016-Mui-SAU-amd64\MuiSetup_????_amd64.msi not found";
        Exit 1;
    }
    Remove-Item C:\Install\Dynamics\CRM2016-Mui-ENU-amd64 -Recurse -Force;
    Expand-Dynamics365Resource ".\CRM2016-Mui-ENU-amd64.exe" -TargetDirectory "C:\Install\Dynamics\CRM2016-Mui-ENU-amd64";
    $msiFile = Get-ChildItem "C:\Install\Dynamics\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi";
    if ( $msiFile.Count -ge 1 ) {
        Write-Output "File C:\Install\Dynamics\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi found";
    } else {
        Write-Output "File C:\Install\Dynamics\CRM2016-Mui-ENU-amd64\MuiSetup_????_amd64.msi not found";
        Exit 1;
    }
} catch {
    Write-Output $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
Write-Host "Test OK"
Exit 0;