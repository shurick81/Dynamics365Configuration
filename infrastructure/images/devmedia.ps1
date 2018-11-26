$configName = "DevMedia"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xPSDesiredStateConfiguration -Name xRemoteFile -ModuleVersion 8.4.0.0

        Node $AllNodes.NodeName
        {

            if ( $env:SPDEVOPSSTARTER_LOCALVS -eq 1 )
            {

                xRemoteFile VSMediaArchive
                {
                    Uri             = "http://$env:PACKER_HTTP_ADDR/VS2017.zip"
                    DestinationPath = "C:\Install\VS2017.zip"
                    MatchSource     = $false
                }

                Archive VSMediaArchiveUnpacked
                {
                    Ensure      = "Present"
                    Path        = "C:\Install\VS2017.zip"
                    Destination = "C:\Install\VSInstall"
                    DependsOn   = "[xRemoteFile]VSMediaArchive"
                }

            } else {

                xRemoteFile VSMediaBootstrapperDownloaded
                {
                    Uri             = "https://download.visualstudio.microsoft.com/download/pr/12221250/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe"
                    DestinationPath = "C:\Install\VSInstall\vs_Enterprise.exe"
                    MatchSource     = $false
                }

            }

            if ( $env:SPDEVOPSSTARTER_LOCALSSMS -eq 1 )
            {

                xRemoteFile SSMSMedia
                {
                    Uri             = "http://$env:PACKER_HTTP_ADDR/SSMS-Setup-ENU.exe"
                    DestinationPath = "C:\Install\SSMS-Setup-ENU.exe"
                    MatchSource     = $false
                }

            } else {

                xRemoteFile SSMSMedia
                {
                    Uri             = "https://download.microsoft.com/download/C/3/D/C3DBFF11-C72E-429A-A861-4C316524368F/SSMS-Setup-ENU.exe"
                    DestinationPath = "C:\Install\SSMS-Setup-ENU.exe"
                    MatchSource     = $false
                }

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
    Start-DscConfiguration $configName -Verbose -Wait -Force;
}
catch
{
    Write-Host "$(Get-Date) Exception in starting DCS:"
    $_.Exception.Message
    Exit 1;
}
if ( $env:SPDEVOPSSTARTER_NODSCTEST -ne "TRUE" )
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
