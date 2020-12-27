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
            $SqlRSAccountCredential,
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
            $DeploymentServiceAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $SandboxServiceAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $VSSWriterServiceAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $AsyncServiceAccountCredential,
            [Parameter(Mandatory=$true)]
            [ValidateNotNullorEmpty()]
            [PSCredential]
            $MonitoringServiceAccountCredential
        )
        Import-DscResource -ModuleName PSDesiredStateConfiguration
        Import-DscResource -ModuleName ActiveDirectoryDsc -ModuleVersion 6.0.1

        $domainName = "contoso.local";

        Node $AllNodes.NodeName
        {

            ADUser SqlRSAccountCredentialUser
            {
                DomainName              = $domainName
                UserName                = $SqlRSAccountCredential.GetNetworkCredential().UserName
                Password                = $SqlRSAccountCredential
                PasswordNeverExpires    = $true
            }
            
            ADUser CRMInstallAccountUser
            {
                DomainName              = $domainName
                UserName                = $CRMInstallAccountCredential.GetNetworkCredential().UserName
                Password                = $CRMInstallAccountCredential
                PasswordNeverExpires    = $true
            }
            
            ADUser CRMServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $CRMServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $CRMServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            ADUser DeploymentServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $DeploymentServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $DeploymentServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            ADUser SandboxServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $SandboxServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $SandboxServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            ADUser VSSWriterServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $VSSWriterServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $VSSWriterServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            ADUser AsyncServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $AsyncServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $AsyncServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            ADUser MonitoringServiceAccountUser
            {
                DomainName              = $domainName
                UserName                = $MonitoringServiceAccountCredential.GetNetworkCredential().UserName
                Password                = $MonitoringServiceAccountCredential
                PasswordNeverExpires    = $true
            }

            ADGroup CRMAdminGroup
            {
                GroupName           = "CRM Administrators 00"
                MembersToInclude    = $CRMInstallAccountCredential.GetNetworkCredential().UserName
                DependsOn           = "[ADUser]CRMInstallAccountUser"
            }
            
            #Organization unit with groups pre-provisioned
            ADOrganizationalUnit CRMGroupsOU00
            {
                Name = "CRM groups 00"
                Path = "DC=$($domainName.Replace( ".", ",DC=" ) )"
            }

            ADGroup CRMPrivUserGroup00
            {
                GroupName           = "CRM01PrivUserGroup00"
                MembersToInclude    = $SqlRSAccountCredential.GetNetworkCredential().UserName, $AsyncServiceAccountCredential.GetNetworkCredential().UserName, $DeploymentServiceAccountCredential.GetNetworkCredential().UserName, $CRMServiceAccountCredential.GetNetworkCredential().UserName, $VSSWriterServiceAccountCredential.GetNetworkCredential().UserName
                GroupScope          = "Universal"
                Path                = "OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn           = "[ADOrganizationalUnit]CRMGroupsOU00", "[ADUser]SqlRSAccountCredentialUser", "[ADUser]AsyncServiceAccountUser", "[ADUser]DeploymentServiceAccountUser", "[ADUser]CRMServiceAccountUser", "[ADUser]VSSWriterServiceAccountUser"
            }

            ADObjectPermissionEntry CRMPrivUserGroupAccessers00
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01PrivUserGroup00,OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMPrivUserGroup00", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMSQLAccessGroup00
            {
                GroupName           = "CRM01SQLAccessGroup00"
                MembersToInclude    = $AsyncServiceAccountCredential.GetNetworkCredential().UserName, $DeploymentServiceAccountCredential.GetNetworkCredential().UserName, $MonitoringServiceAccountCredential.GetNetworkCredential().UserName, $CRMServiceAccountCredential.GetNetworkCredential().UserName, $VSSWriterServiceAccountCredential.GetNetworkCredential().UserName
                GroupScope          = "Universal"
                Path                = "OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn           = "[ADOrganizationalUnit]CRMGroupsOU00", "[ADUser]AsyncServiceAccountUser", "[ADUser]DeploymentServiceAccountUser", "[ADUser]MonitoringServiceAccountUser", "[ADUser]CRMServiceAccountUser", "[ADUser]VSSWriterServiceAccountUser"
            }

            ADObjectPermissionEntry CRMSQLAccessGroupAccessers00
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01SQLAccessGroup00,OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMSQLAccessGroup00", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMUserGroup00
            {
                GroupName        = "CRM01UserGroup00"
                Path             = "OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn        = "[ADOrganizationalUnit]CRMGroupsOU00"
            }

            ADObjectPermissionEntry CRMUserGroupAccessers00
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01UserGroup00,OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMUserGroup00", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMReportingGroup00
            {
                GroupName           = "CRM01ReportingGroup00"
                GroupScope          = "Universal"
                MembersToInclude    = $CRMInstallAccountCredential.GetNetworkCredential().UserName
                Path                = "OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn           = "[ADOrganizationalUnit]CRMGroupsOU00"
            }

            ADObjectPermissionEntry CRMReportingGroupAccessers00
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01ReportingGroup00,OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMReportingGroup00", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMPrivReportingGroup00
            {
                GroupName           = "CRM01PrivReportingGroup00"
                GroupScope          = "Universal"
                MembersToInclude    = $SqlRSAccountCredential.GetNetworkCredential().UserName
                Path                = "OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn           = "[ADOrganizationalUnit]CRMGroupsOU00", "[ADUser]SqlRSAccountCredentialUser"
            }

            ADObjectPermissionEntry CRMPrivReportingGroupAccessers00
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01PrivReportingGroup00,OU=CRM groups 00,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMPrivReportingGroup00", "[ADUser]DeploymentServiceAccountUser"
            }

            #Organization unit with no groups but full permissions
            ADOrganizationalUnit CRMGroupsOU01
            {
                Name = "CRM groups 01"
                Path = "DC=$($domainName.Replace( ".", ",DC=" ) )"
            }

            ADObjectPermissionEntry OUPermissions
            {
                Ensure                             = 'Present'
                Path                               = "OU=CRM groups 01,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = "$($domainName.Split( "." )[0].ToUpper())\CRM Administrators 00"
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADOrganizationalUnit]CRMGroupsOU01", "[ADGroup]CRMAdminGroup"
            }

            #Organization unit with pre-created groups without members, but with full permissions
            ADOrganizationalUnit CRMGroupsOU02
            {
                Name = "CRM groups 02"
                Path = "DC=$($domainName.Replace( ".", ",DC=" ) )"
            }

            ADObjectPermissionEntry OUPermissions02
            {
                Ensure                              = 'Present'
                Path                                = "OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                   = "$($domainName.Split( "." )[0].ToUpper())\CRM Administrators 00"
                ActiveDirectoryRights               = 'GenericAll'
                AccessControlType                   = 'Allow'
                ObjectType                          = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance  = 'All'
                InheritedObjectType                 = '00000000-0000-0000-0000-000000000000'
                DependsOn                           = "[ADOrganizationalUnit]CRMGroupsOU02", "[ADGroup]CRMAdminGroup"
            }

            ADGroup CRMPrivUserGroup02
            {
                GroupName   = "CRM01PrivUserGroup02"
                GroupScope  = "Universal"
                Path        = "OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn   = "[ADOrganizationalUnit]CRMGroupsOU00", "[ADUser]CRMInstallAccountUser"
            }

            ADObjectPermissionEntry CRMPrivUserGroupAccessers02
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01PrivUserGroup02,OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMPrivUserGroup02", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMSQLAccessGroup02
            {
                GroupName   = "CRM01SQLAccessGroup02"
                GroupScope  = "Universal"
                Path        = "OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn   = "[ADOrganizationalUnit]CRMGroupsOU02"
            }

            ADObjectPermissionEntry CRMSQLAccessGroupAccessers02
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01SQLAccessGroup02,OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMSQLAccessGroup02", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMUserGroup02
            {
                GroupName   = "CRM01UserGroup02"
                Path        = "OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn   = "[ADOrganizationalUnit]CRMGroupsOU02"
            }

            ADObjectPermissionEntry CRMUserGroupAccessers02
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01UserGroup02,OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMUserGroup02", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMReportingGroup02
            {
                GroupName   = "CRM01ReportingGroup02"
                GroupScope  = "Universal"
                Path        = "OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn   = "[ADOrganizationalUnit]CRMGroupsOU02"
            }

            ADObjectPermissionEntry CRMReportingGroupAccessers02
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01ReportingGroup02,OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMReportingGroup02", "[ADUser]DeploymentServiceAccountUser"
            }

            ADGroup CRMPrivReportingGroup02
            {
                GroupName   = "CRM01PrivReportingGroup02"
                GroupScope  = "Universal"
                Path        = "OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                DependsOn   = "[ADOrganizationalUnit]CRMGroupsOU02"
            }

            ADObjectPermissionEntry CRMPrivReportingGroupAccessers02
            {
                Ensure                             = 'Present'
                Path                               = "CN=CRM01PrivReportingGroup02,OU=CRM groups 02,DC=$($domainName.Replace( ".", ",DC=" ) )"
                IdentityReference                  = $DeploymentServiceAccountCredential.UserName
                ActiveDirectoryRights              = 'GenericAll'
                AccessControlType                  = 'Allow'
                ObjectType                         = '00000000-0000-0000-0000-000000000000'
                ActiveDirectorySecurityInheritance = 'All'
                InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
                DependsOn                          = "[ADGroup]CRMPrivReportingGroup02", "[ADUser]DeploymentServiceAccountUser"
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
$CRMInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmadmin", $securedPassword );
$CRMServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsrv", $securedPassword );
$DeploymentServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmdplsrv", $securedPassword );
$SandboxServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmsandbox", $securedPassword );
$VSSWriterServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmvsswrit", $securedPassword );
$AsyncServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmasync", $securedPassword );
$MonitoringServiceAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_crmmon", $securedPassword );
Write-Host "$(Get-Date) Compiling DSC"
try
{
    &$configName `
        -ConfigurationData $configurationData `
        -SqlRSAccountCredential $SqlRSAccountCredential `
        -CRMInstallAccountCredential $CRMInstallAccountCredential `
        -CRMServiceAccountCredential $CRMServiceAccountCredential `
        -DeploymentServiceAccountCredential $DeploymentServiceAccountCredential `
        -SandboxServiceAccountCredential $SandboxServiceAccountCredential `
        -VSSWriterServiceAccountCredential $VSSWriterServiceAccountCredential `
        -AsyncServiceAccountCredential $AsyncServiceAccountCredential `
        -MonitoringServiceAccountCredential $MonitoringServiceAccountCredential;
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
