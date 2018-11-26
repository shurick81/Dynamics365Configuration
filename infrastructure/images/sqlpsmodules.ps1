$configName = "SQLPSModules"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName PackageManagementProviderResource -ModuleVersion 1.0.3

        Node $AllNodes.NodeName
        {

            PSModule "PSModule_xPendingReboot"
            {
                Ensure              = "Present"
                Name                = "xPendingReboot"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "0.3.0.0"
            }

            PSModule "PSModule_StorageDsc"
            {
                Ensure              = "Present"
                Name                = "StorageDsc"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "4.0.0.0"
            }
    
            PSModule "PSModule_xNetworking"
            {
                Ensure              = "Present"
                Name                = "xNetworking"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "5.6.0.0"
            }

            PSModule "PSModule_SqlServerDsc"
            {
                Ensure              = "Present"
                Name                = "SqlServerDsc"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "11.1.0.0"
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
