$configName = "SQLMedia"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )
    
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.4.0.0
        Import-DscResource -ModuleName StorageDsc -ModuleVersion 4.0.0.0
    
        Node $AllNodes.NodeName
        {
    
            $SQLImageUrl = "https://download.microsoft.com/download/F/E/9/FE9397FA-BFAB-4ADD-8B97-91234BC774B2/SQLServer2016-x64-ENU.iso";
            $SQLImageUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
            $SQLImageFileName = $matches[0]
            $SQLImageDestinationPath = "C:\Install\SQL2016RTMImage\$SQLImageFileName"
    
            xRemoteFile SQLServerImageFilePresent
            {
                Uri             = $SQLImageUrl
                DestinationPath = $SQLImageDestinationPath
                MatchSource     = $false
            }
    
            MountImage SQLServerImageMounted
            {
                ImagePath   = $SQLImageDestinationPath
                DriveLetter = 'S'
                DependsOn   = "[xRemoteFile]SQLServerImageFilePresent"
            }
    
            WaitForVolume SQLServerImageMounted
            {
                DriveLetter         = 'S'
                RetryIntervalSec    = 5
                RetryCount          = 10
                DependsOn           = "[MountImage]SQLServerImageMounted"
            }

            xRemoteFile SQLServerSP2FilePresent
            {
                Uri             = "https://download.microsoft.com/download/9/2/B/92BAD988-00C5-4F68-811E-B7FFBE009B00/SQLServer2016SP2-KB4052908-x64-ENU.exe"
                DestinationPath = "C:\Install\SQL2016Updates\SQLServer2016SP2-KB4052908-x64-ENU.exe"
                MatchSource     = $false
            }
    
        }
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in defining DCS:"
    $_.Exception.Message
    Exit 1;
}
$configurationData = @{ AllNodes = @(
    @{ NodeName = $env:COMPUTERNAME; PSDscAllowPlainTextPassword = $True; PsDscAllowDomainUser = $True }
) }
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData;
}
catch
{
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Starting DSC"
try
{
    if ( $env:VMDEVOPSSTARTER_NODSCWAIT )
    {
        Start-DscConfiguration $configName -Verbose -Force;
        Sleep 20;
        0..720 | % {
            $res = Get-DscLocalConfigurationManager;
            Write-Host $res.LCMState;
            if ( ( $res.LCMState -ne "Idle" ) -and ( $res.LCMState -ne "PendingConfiguration" ) ) {
                Sleep 10;
            }
        }
        if ( ( $res.LCMState -ne "Idle" ) -and ( $res.LCMState -ne "PendingConfiguration" ) ) {
            Write-Host "Timouted waiting for LCMState"
            Exit 1;
        }
    } else {
        Start-DscConfiguration $configName -Verbose -Wait -Force;
    }
}
catch
{
    Write-Host "$(Get-Date) Exception in starting DCS:"
    $_.Exception.Message
    Exit 1;
}
if ( $env:VMDEVOPSSTARTER_NODSCTEST -ne "TRUE" )
{
    Write-Host "$(Get-Date) Testing DSC"
    try {
        $result = Test-DscConfiguration $configName -Verbose;
        $inDesiredState = $result.InDesiredState;
        $failed = $false;
        $inDesiredState | % {
            if ( !$_ ) {
                Write-Host "$(Get-Date) Test failed"
                Exit 1;
            }
        }
    }
    catch {
        Write-Host "$(Get-Date) Exception in testing DCS:"
        $_.Exception.Message
        Exit 1;
    }
} else {
    Write-Host "$(Get-Date) Skipping tests"
}
Exit 0;
