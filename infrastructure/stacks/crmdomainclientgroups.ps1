$configName = "DomainClientGroups"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $DomainAdminCredential
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName SecurityPolicyDsc -ModuleVersion 2.10.0.0

        Node $AllNodes.NodeName
        {        

            Group AdminGroup
            {
                GroupName           = "Administrators"
                Credential          = $DomainAdminCredential
                MembersToInclude    = "contoso\CRM Administrators 00"
            }

            Group PerformanceUserGroup
            {
                GroupName           = "Performance Log Users"
                Credential          = $DomainAdminCredential
                MembersToInclude    = "contoso\_crmasync", "contoso\_crmsrv"
            }

            UserRightsAssignment LogonAsAService
            {
                Policy      = "Log_on_as_a_service"
                Identity    = "contoso\_crmvsswrit", "contoso\_ssrs"
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

$securedPassword = ConvertTo-SecureString "Fractalsol365" -AsPlainText -Force
$DomainAdminCredential = New-Object System.Management.Automation.PSCredential( "contoso\vagrant", $securedPassword )
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -DomainAdminCredential $DomainAdminCredential;
}
catch
{
    Write-Host "$(Get-Date) Exception in compiling DCS:";
    $_.Exception.Message
    Exit 1;
}
Write-Host "$(Get-Date) Starting DSC"
if ( $env:VMDEVOPSSTARTER_TRIALS ) {
    $trialsLeft = [int]$env:VMDEVOPSSTARTER_TRIALS;
} else {
    $trialsLeft = 1;
}
$complete = $false;
while ( !$complete -and ( $trialsLeft -gt 0 ) ) {
    Write-Host "$(Get-Date) Trials left: $trialsLeft"
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
    $trialsLeft--;
    if ( $env:VMDEVOPSSTARTER_NODSCTEST -ne "TRUE" )
    {
        $failed = $false;
        Write-Host "$(Get-Date) Testing DSC"
        try {
            $result = Test-DscConfiguration $configName -Verbose;
            $inDesiredState = $result.InDesiredState;
            $inDesiredState | % {
                if ( !$_ ) {
                    Write-Host "$(Get-Date) Test failed"
                    $failed = $true;
                }
            }
        }
        catch {
            Write-Host "$(Get-Date) Exception in testing DCS:"
            $_.Exception.Message
            Exit 1;
        }
        $complete = !$failed;
        Sleep 15;
    } else {
        Write-Host "$(Get-Date) Skipping tests"
        $complete = ( $trialsLeft -eq 0 )
    }
}
if ( $complete ) {
    Write-Host "$(Get-Date) Configuration is applied successfully"
    Exit 0;
} else {
    Write-Host "$(Get-Date) Configuration is not applied"
    Exit 1;
}
