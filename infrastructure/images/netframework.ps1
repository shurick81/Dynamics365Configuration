$configName = "Framework"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.4.0.0
        Import-DscResource -ModuleName xWindowsUpdate -ModuleVersion 2.7.0.0

        xRemoteFile NET84
        {
            Uri             = "http://download.windowsupdate.com/c/msdownload/update/software/ftpk/2020/01/windows10.0-kb4486129-x64_0b61d9a03db731562e0a0b49383342a4d8cbe36a.msu"
            DestinationPath = "C:\Install\NET\windows10.0-kb4486129-x64_0b61d9a03db731562e0a0b49383342a4d8cbe36a.msu"
            MatchSource     = $false
        }
 
        xHotfix NET84
        {
            Path        = "C:\Install\NET\windows10.0-kb4486129-x64_0b61d9a03db731562e0a0b49383342a4d8cbe36a.msu"
            Id          = 'KB4486129'
            DependsOn   = "[xRemoteFile]NET84"
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
    Start-DscConfiguration $configName -Verbose -Wait -Force;
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
