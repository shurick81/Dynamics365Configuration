$configName = "DNSRecords"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $OOSPfxCredential
        )

        Import-DscResource -ModuleName PSDesiredStateConfiguration 
        Import-DscResource -ModuleName xDnsServer -ModuleVersion 1.9.0.0

        Node $AllNodes.NodeName
        {        

            xDnsRecord "xDnsCNAMERecordOOS"
            {
                Name    = "oos"
                Type    = "CName"
                Target  = "OOS01.contoso.local"
                Zone    = "contoso.local"
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
$OOSPfxCredential = New-Object System.Management.Automation.PSCredential( "contoso\vagrant", $securedPassword )
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -OOSPfxCredential $OOSPfxCredential;
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
