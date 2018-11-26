$configName = "DevPSModules"
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

            PSModule "PSModule_cChoco"
            {
                Ensure              = "Present"
                Name                = "cChoco"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "2.3.1.0"
            }

            PSModule "PSModule_xSystemSecurity"
            {
                Ensure              = "Present"
                Name                = "xSystemSecurity"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "1.4.0.0"
            }
            
            PSModule "PSModule_PSPKI"
            {
                Ensure              = "Present"
                Name                = "PSPKI"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "3.3.0.0"
            }
            
            PSModule "PSModule_xSmbShare"
            {
                Ensure              = "Present"
                Name                = "xSmbShare"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "2.1.0.0"
            }

            PSModule "PSModule_CertificateDsc"
            {
                Ensure              = "Present"
                Name                = "CertificateDsc"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "4.1.0.0"
            }

            PSModule "PSModule_CredentialManager"
            {
                Ensure              = "Present"
                Name                = "CredentialManager"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "2.0"
            }

            PSModule "PSModule_SharePointPnPPowerShell2013"
            {
                Ensure              = "Present"
                Name                = "SharePointPnPPowerShell2013"
                Repository          = "PSGallery"
                InstallationPolicy  = "Trusted"
                RequiredVersion     = "3.1.1809.0"
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
