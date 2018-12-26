$configName = "CRMDomainLocalInstall"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
        )
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.21.0.0

        $domainName = "contoso.local";

        Node $AllNodes.NodeName
        {

            xADGroup AdminGroup
            {
                GroupName           = "Administrators"
                MembersToInclude    = "CRM01PrivUserGroup"
            }

            xADGroup PerformanceUserGroup
            {
                GroupName           = "Performance Log Users"
                MembersToInclude    = "_crmasync", "_crmsrv"
            }

            Registry CredSSPAllowNTLM
            {
                Ensure      = "Present"
                Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
                ValueName   = "AllowFreshCredentialsWhenNTLMOnly"
                ValueType   = "DWORD"
                ValueData   = "1"
            }

            Registry CredSSPConcatenateNTLM
            {
                Ensure      = "Present"
                Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
                ValueName   = "ConcatenateDefaults_AllowFreshNTLMOnly"
                ValueType   = "DWORD"
                ValueData   = "1"
            }

            Registry CredSSPContoso
            {
                Ensure      = "Present"
                Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation\AllowFreshCredentialsWhenNTLMOnly"
                ValueName   = "1"
                ValueData   = "wsman/*.contoso.local"
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
