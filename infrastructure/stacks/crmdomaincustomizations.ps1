$configName = "SPDomainCustomizations"
Write-Host "$(Get-Date) Defining DSC"
try
{
    Configuration $configName
    {
        param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $CRMInstallAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $CRMServiceAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $CRMSandboxAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $CRMVSSWriterAccountCredential
        )
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName xActiveDirectory -ModuleVersion 2.21.0.0

        $domainName = "contoso.local";

        Node $AllNodes.NodeName
        {

            xADUser CRMInstallAccountUser
            {
                DomainName              = $domainName
                UserName                = $CRMInstallAccountCredential.GetNetworkCredential().UserName
                Password                = $CRMInstallAccountCredential
                PasswordNeverExpires    = $true
            }
            
            xADUser CRMServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $CRMServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $CRMServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser CRMSandboxAccountUser
            {
                DomainName              = $domainName
                UserName                = $CRMSandboxAccountCredential.GetNetworkCredential().UserName
                Password                = $CRMSandboxAccountCredential
                PasswordNeverExpires    = $true
            }

            xADUser CRMVSSWriterAccountUser
            {
                DomainName              = $domainName
                UserName                = $CRMVSSWriterAccountCredential.GetNetworkCredential().UserName
                Password                = $CRMVSSWriterAccountCredential
                PasswordNeverExpires    = $true
            }

            xADGroup CRMAdminGroup
            {
                GroupName           = "OG CRM Server Admin Prod"
                MembersToInclude    = $CRMInstallAccountCredential.GetNetworkCredential().UserName
                DependsOn           = "[xADUser]CRMInstallAccountUser"
            }

            xADGroup CRMPrivUserGroup
            {
                GroupName           = "CRM01PrivUserGroup"
                MembersToInclude    = $CRMInstallAccountCredential.GetNetworkCredential().UserName
                DependsOn           = "[xADUser]CRMInstallAccountUser"
            }
            
            xADGroup CRMSQLAccessGroup
            {
                GroupName           = "CRM01SQLAccessGroup"
            }

            xADGroup CRMUserGroup
            {
                GroupName           = "CRM01UserGroup"
            }

            xADGroup CRMReportingGroup
            {
                GroupName           = "CRM01ReportingGroup"
            }

            xADGroup CRMPrivReportingGroup
            {
                GroupName           = "CRM01PrivReportingGroup"
            }

            xADOrganizationalUnit CRMGroupsOU
            {
               Name = "CRM groups"
               Path = "DC=contoso,DC=local"
            }

            xADObjectPermissionEntry OUPermissions
            {
                Ensure                             = 'Present'
                Path                               = 'OU=CRM groups,DC=contoso,DC=local'
                IdentityReference                  = 'contoso\OG CRM Server Admin Prod'
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'None'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
            }
        
            xADGroup EnterpriseAdminGroup
            {
                GroupName           = "Enterprise Admins"
                MembersToInclude    = $CRMInstallAccountCredential.GetNetworkCredential().UserName
            }

            xADGroup SQLAdminGroup
            {
                GroupName           = "SQLAdmins"
                MembersToInclude    = "OG CRM Server Admin Prod"
                DependsOn           = "[xADGroup]CRMAdminGroup"
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
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
$CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
$CRMSandboxAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
$CRMVSSWriterAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -CRMInstallAccountCredential $CRMInstallAccountCredential `
        -CRMServiceAccountCredential $CRMServiceAccountCredential `
        -CRMSandboxAccountCredential $CRMSandboxAccountCredential `
        -CRMVSSWriterAccountCredential $CRMVSSWriterAccountCredential;
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
