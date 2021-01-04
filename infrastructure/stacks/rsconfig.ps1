$configName = "RSConfig"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $SqlRSAccountCredential
        )
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName SqlServerDsc -ModuleVersion 14.2.1
        Import-DscResource -ModuleName xNetworking -ModuleVersion 5.6.0.0

        $domainName = "contoso.local";

        Node $AllNodes.NodeName
        {

            SqlRS ReportingServicesConfig
            {
                InstanceName                    = 'SSRS'
                DatabaseServerName              = $NodeName
                DatabaseInstanceName            = 'SQLInstance01'
                ReportServerVirtualDirectory    = "ReportServer_SSRS"
                ReportsVirtualDirectory         = "Reports_SSRS"
                ReportServerReservedUrl         = @( 'http://+:80' )
                ReportsReservedUrl              = @( 'http://+:80' )
            }

            xFireWall AllowHTTP
            {
                Name        = "HTTP"
                DisplayName = "HTTP"
                Ensure      = "Present"
                Enabled     = "True"
                Profile     = 'Domain', 'Private', 'Public'
                Direction   = "InBound"
                LocalPort   = 80
                Protocol    = "TCP"
                Description = "Firewall rule to allow web sites publishing"
            }
            
            xFireWall WMI-WINMGMT-In-TCP
            {
                Name        = "WMI-WINMGMT-In-TCP"
                Enabled     = "True"
            }
            
            xFireWall WMI-RPCSS-In-TCP
            {
                Name        = "WMI-RPCSS-In-TCP"
                Enabled     = "True"
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

$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$SqlRSAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_ssrs", $securedPassword );
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -SqlRSAccountCredential $SqlRSAccountCredential;
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
