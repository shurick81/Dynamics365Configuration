﻿function Install-Dynamics365Server {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $MediaDir,
        [Parameter(Mandatory=$true)]
        [string]
        $LicenseKey,
        [Parameter(Mandatory=$true)]
        [string]
        $SqlServer,
        [switch]
        $CreateDatabase,
        [ValidateSet(
            "FrontEnd",
            "BackEnd",
            "DeploymentAdministration",
            "WebApplicationServer",
            "OrganizationWebService",
            "DiscoveryWebService",
            "HelpServer",
            "AsynchronousProcessingService",
            "EmailConnector",
            "SandboxProcessingService",
            "DeploymentTools",
            "DeploymentWebService",
            "VSSWriter"
        )]
        [string[]]
        $ServerRoles,
        [string]
        $PrivUserGroup,
        [string]
        $SQLAccessGroup,
        [string]
        $UserGroup,
        [string]
        $ReportingGroup,
        [string]
        $PrivReportingGroup,
        [pscredential]
        $CrmServiceAccount,
        [pscredential]
        $DeploymentServiceAccount,
        [pscredential]
        $SandboxServiceAccount,
        [pscredential]
        $VSSWriterServiceAccount,
        [pscredential]
        $AsyncServiceAccount,
        [pscredential]
        $MonitoringServiceAccount,
        [switch]
        $CreateWebSite,
        [int]
        $WebSitePort,
        [string]
        $WebSiteUrl,
        [string]
        $Organization,
        [string]
        $OrganizationUniqueName,
        [string]
        $ReportingUrl,
        [string]
        $InstallDir,
        [string]
        $IncomingExchangeServer,
        [string]
        $BaseISOCurrencyCode,
        [string]
        $BaseCurrencyName,
        [string]
        $BaseCurrencySymbol,
        [int]
        $BaseCurrencyPrecision,
        [string]
        $OrganizationCollation,
        [switch]
        $SQM = $false,
        [switch]
        $MUOptin = $false,
        [switch]
        $Reboot = $false,
        [string]
        $LogFilePath = $null,
        [ValidateRange(1,3600)]
        [int]
        $LogFilePullIntervalInSeconds = 30,
        [switch]
        $LogFilePullToOutput = $false
    )
    if ( $ServerRoles ) {
        $serverRoleModel = @{
            FrontEnd = (
                "WebApplicationServer",
                "OrganizationWebService",
                "DiscoveryWebService",
                "HelpServer"
            )
            BackEnd = @(
                "AsynchronousProcessingService",
                "EmailConnector",
                "SandboxProcessingService"
            )
            DeploymentAdministration = @(
                "DeploymentTools",
                "DeploymentWebService",
                "VSSWriter"
            )
        }
        $refinedRoles = $ServerRoles | ForEach-Object {
            $roleOrGroupName = $_;
            switch ( $roleOrGroupName ) {
                "FrontEnd" {
                    Write-Output "WebApplicationServer";
                    Write-Output "OrganizationWebService";
                    Write-Output "DiscoveryWebService";
                    Write-Output "HelpServer";
                    break;
                }
                "BackEnd" {
                    Write-Output "AsynchronousProcessingService";
                    Write-Output "EmailConnector";
                    Write-Output "SandboxProcessingService";
                    break;
                }
                "DeploymentAdministration" {
                    Write-Output "DeploymentTools";
                    Write-Output "DeploymentWebService";
                    Write-Output "VSSWriter";
                    break;
                }
                default {
                    Write-Output $roleOrGroupName;
                    break;
                }
            }
        } | Select-Object -Unique;
        $ServerRoles = $refinedRoles;
        Write-Output "Refined server roles:";
        Write-Output $ServerRoles;
    } else {
        Write-Output "Specific roles are not requested, so full server will be installed";
    }
    $setupFilePath = "$mediaDir\SetupServer.exe";
    if ( Test-Path $setupFilePath ) {
        $fileVersion = [version]( Get-Command $setupFilePath ).FileVersionInfo.FileVersion;
        Write-Output "Version of software to be installed: $($fileVersion.ToString())";
        if ( Test-Path "$mediaDir\LangPacks" ) {
            $languagePacks = Get-ChildItem "$mediaDir\LangPacks";
            if ( $languagePacks -and $languagePacks.Count -eq 1 ) {
                $fileLanguageCode = [int]$languagePacks.Name;
                Write-Output "Language code of software to be installed: $fileLanguageCode";
                $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
                If ( $msCRMRegistryValues ) {
                    $isInstalled = $true;
                    $installedVersion = Get-Dynamics365ServerVersion;
                    if ( $installedVersion -ne $fileVersion ) {
                        $errorMessage = "Another version is already installed: $($installedVersion.ToString())";
                        Write-Output $errorMessage;
                        Throw $errorMessage;
                    }
                    $installedLanguage = Get-Dynamics365ServerLanguage;
                    if ( $installedLanguage -ne $fileLanguageCode ) {
                        $errorMessage = "Another language is already installed: $installedLanguage";
                        Write-Output $errorMessage;
                        Throw $errorMessage;
                    }
                } else {
                    $isInstalled = $false;
                }
                if ( !$isInstalled ) {
                    $xml = [xml]"";
                    $crmSetupElement = $xml.CreateElement( "CRMSetup" );
                        $serverElement = $xml.CreateElement( "Server" );
                            #Patch is a required element for setup
                            $patchElement = $xml.CreateElement( "Patch" );
                                $patchElement.SetAttribute( "Update", $false ) | Out-Null;
                            $serverElement.AppendChild( $patchElement ) | Out-Null;
                            $licenseKeyElement = $xml.CreateElement( "LicenseKey" );
                                $licenseKeyElement.InnerText = $licenseKey;
                            $serverElement.AppendChild( $licenseKeyElement ) | Out-Null;
                            if ( $installDir ) {
                                $installDirElement = $xml.CreateElement( "InstallDir" );
                                    $installDirElement.InnerText = $installDir;
                                $serverElement.AppendChild( $installDirElement ) | Out-Null;
                            }
                            $databaseElement = $xml.CreateElement( "Database" );
                                $databaseElement.SetAttribute( "create", $CreateDatabase ) | Out-Null;
                            $serverElement.AppendChild( $databaseElement ) | Out-Null;
                            $SQLServerElement = $xml.CreateElement( "SqlServer" );
                                $SQLServerElement.InnerText = $SQLServer;
                            $serverElement.AppendChild( $SQLServerElement ) | Out-Null;
                            if ( $privUserGroup -or $SQLAccessGroup -or $userGroup -or $reportingGroup -or $privReportingGroup ) {
                                $groupsElement = $xml.CreateElement( "Groups" );
                                    $groupsElement.SetAttribute( "autogroupmanagementoff", $false ) | Out-Null;
                                    if ( $privUserGroup ) {
                                        $privUserGroupElement = $xml.CreateElement( "PrivUserGroup" );
                                            $privUserGroupElement.InnerText = $privUserGroup;
                                        $groupsElement.AppendChild( $privUserGroupElement ) | Out-Null;
                                    }
                                    if ( $SQLAccessGroup ) {
                                        $SQLAccessGroupElement = $xml.CreateElement( "SQLAccessGroup" );
                                            $SQLAccessGroupElement.InnerText = $SQLAccessGroup;
                                        $groupsElement.AppendChild( $SQLAccessGroupElement ) | Out-Null;
                                    }
                                    if ( $userGroup ) {
                                        $userGroupElement = $xml.CreateElement( "UserGroup" );
                                            $userGroupElement.InnerText = $userGroup;
                                        $groupsElement.AppendChild( $userGroupElement ) | Out-Null;
                                    }
                                    if ( $reportingGroup ) {
                                        $reportingGroupElement = $xml.CreateElement( "ReportingGroup" );
                                            $reportingGroupElement.InnerText = $reportingGroup;
                                        $groupsElement.AppendChild( $reportingGroupElement ) | Out-Null;
                                    }
                                    if ( $privReportingGroup ) {
                                        $privReportingGroupElement = $xml.CreateElement( "PrivReportingGroup" );
                                            $privReportingGroupElement.InnerText = $privReportingGroup;
                                        $groupsElement.AppendChild( $privReportingGroupElement ) | Out-Null;
                                    }
                                $serverElement.AppendChild( $groupsElement ) | Out-Null;
                            }
                            if ( $CRMServiceAccount ) {
                                $CRMServiceAccountElement = $xml.CreateElement( "CrmServiceAccount" );
                                    $CRMServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                                        $serviceAccountLoginElement.InnerText = $CRMServiceAccount.UserName;
                                    $CRMServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                                        $serviceAccountPasswordElement.InnerText = $CRMServiceAccount.GetNetworkCredential().Password;
                                    $CRMServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                                $serverElement.AppendChild( $CRMServiceAccountElement ) | Out-Null;
                            }
                            if ( $deploymentServiceAccount ) {
                                $deploymentServiceAccountElement = $xml.CreateElement( "DeploymentServiceAccount" );
                                    $deploymentServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                                        $serviceAccountLoginElement.InnerText = $deploymentServiceAccount.UserName;
                                    $deploymentServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                                        $serviceAccountPasswordElement.InnerText = $deploymentServiceAccount.GetNetworkCredential().Password;
                                    $deploymentServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                                $serverElement.AppendChild( $deploymentServiceAccountElement ) | Out-Null;
                            }
                            if ( $sandboxServiceAccount ) {
                                $sandboxServiceAccountElement = $xml.CreateElement( "SandboxServiceAccount" );
                                    $sandboxServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                                        $serviceAccountLoginElement.InnerText = $sandboxServiceAccount.UserName;
                                    $sandboxServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                                        $serviceAccountPasswordElement.InnerText = $sandboxServiceAccount.GetNetworkCredential().Password;
                                    $sandboxServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                                $serverElement.AppendChild( $sandboxServiceAccountElement ) | Out-Null;
                            }
                            if ( $VSSWriterServiceAccount ) {
                                $VSSWriterServiceAccountElement = $xml.CreateElement( "VSSWriterServiceAccount" );
                                    $VSSWriterServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                                        $serviceAccountLoginElement.InnerText = $VSSWriterServiceAccount.UserName;
                                    $VSSWriterServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                                        $serviceAccountPasswordElement.InnerText = $VSSWriterServiceAccount.GetNetworkCredential().Password;
                                    $VSSWriterServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                                $serverElement.AppendChild( $VSSWriterServiceAccountElement ) | Out-Null;
                            }
                            if ( $asyncServiceAccount ) {
                                $asyncServiceAccountElement = $xml.CreateElement( "AsyncServiceAccount" );
                                    $asyncServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                                        $serviceAccountLoginElement.InnerText = $asyncServiceAccount.UserName;
                                    $asyncServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                                        $serviceAccountPasswordElement.InnerText = $asyncServiceAccount.GetNetworkCredential().Password;
                                    $asyncServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                                $serverElement.AppendChild( $asyncServiceAccountElement ) | Out-Null;
                            }
                            if ( $monitoringServiceAccount ) {
                                $monitoringServiceAccountElement = $xml.CreateElement( "MonitoringServiceAccount" );
                                    $monitoringServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                                        $serviceAccountLoginElement.InnerText = $monitoringServiceAccount.UserName;
                                    $monitoringServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                                        $serviceAccountPasswordElement.InnerText = $monitoringServiceAccount.GetNetworkCredential().Password;
                                    $monitoringServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                                $serverElement.AppendChild( $monitoringServiceAccountElement ) | Out-Null;
                            }
                            #WebsiteUrl is required
                            $webSiteUrlElement = $xml.CreateElement( "WebsiteUrl" );
                                $webSiteUrlElement.SetAttribute( "create", $createWebSite ) | Out-Null;
                                $webSiteUrlElement.SetAttribute( "port", $webSitePort ) | Out-Null;
                                $webSiteUrlElement.InnerText = $webSiteUrl;
                            $serverElement.AppendChild( $webSiteUrlElement ) | Out-Null;
                            if ( $ServerRoles ) {
                                $rolesElement = $xml.CreateElement( "Roles" );
                                    $ServerRoles | ForEach-Object {
                                        $roleElement = $xml.CreateElement( "Role" );
                                            $roleElement.SetAttribute( "Name", $_ ) | Out-Null;
                                            $roleElement.SetAttribute( "Action", "Add" ) | Out-Null;
                                        $rolesElement.AppendChild( $roleElement ) | Out-Null;
                                    }
                                $serverElement.AppendChild( $rolesElement ) | Out-Null;
                            }
                            if ( $incomingExchangeServer )
                            {
                                $emailElement = $xml.CreateElement( "Email" );
                                    $incomingExchangeServerElement = $xml.CreateElement( "IncomingExchangeServer" );
                                        $incomingExchangeServerElement.SetAttribute( "name", $incomingExchangeServer ) | Out-Null;
                                    $emailElement.AppendChild( $incomingExchangeServerElement ) | Out-Null;
                                $serverElement.AppendChild( $emailElement ) | Out-Null;
                            }
                            if ( $organizationUniqueName ) {
                                $organizationUniqueNameElement = $xml.CreateElement( "OrganizationUniqueName" );
                                    $organizationUniqueNameElement.InnerText = $organizationUniqueName;
                                $serverElement.AppendChild( $organizationUniqueNameElement ) | Out-Null;
                            }
                            if ( $organization ) {
                                $organizationElement = $xml.CreateElement( "Organization" );
                                    $organizationElement.InnerText = $organization;
                                $serverElement.AppendChild( $organizationElement ) | Out-Null;
                            }
                            if ( $baseISOCurrencyCode -or $baseCurrencyName -or $baseCurrencySymbol -or $baseCurrencyPrecision )
                            {
                                $baseCurrencyElement = $xml.CreateElement( "basecurrency" );
                                if ( $baseISOCurrencyCode )
                                {
                                    $baseCurrencyElement.SetAttribute( "isocurrencycode", $baseISOCurrencyCode ) | Out-Null;
                                }
                                if ( $baseCurrencyName )
                                {
                                    $baseCurrencyElement.SetAttribute( "currencyname", $baseCurrencyName ) | Out-Null;
                                }
                                if ( $baseCurrencySymbol )
                                {
                                    $baseCurrencyElement.SetAttribute( "currencysymbol", $baseCurrencySymbol ) | Out-Null;
                                }
                                if ( $baseCurrencyPrecision )
                                {
                                    $baseCurrencyElement.SetAttribute( "currencyprecision", $baseCurrencyPrecision ) | Out-Null;
                                }
                                $serverElement.AppendChild( $baseCurrencyElement ) | Out-Null;
                            }
                            if ( $organizationCollation )
                            {
                                $organizationCollationElement = $xml.CreateElement( "OrganizationCollation" );
                                    $organizationCollationElement.InnerText = $organizationCollation;
                                $serverElement.AppendChild( $organizationCollationElement ) | Out-Null;
                            }
                            if ( $ReportingUrl ) {
                                $reportingElement = $xml.CreateElement( "Reporting" );
                                    $reportingElement.SetAttribute( "URL", $ReportingUrl ) | Out-Null;
                                $serverElement.AppendChild( $reportingElement ) | Out-Null;
                            }
                            $SQMElement = $xml.CreateElement( "SQM" );
                                $SQMElement.SetAttribute( "optin", $SQM ) | Out-Null;
                            $serverElement.AppendChild( $SQMElement ) | Out-Null;
                            $MUOptinElement = $xml.CreateElement( "muoptin" );
                                $MUOptinElement.SetAttribute( "optin", $MUOptin ) | Out-Null;
                            $serverElement.AppendChild( $MUOptinElement ) | Out-Null;
                            $remoteInstallElement = $xml.CreateElement( "remoteinstall" );
                                $remoteInstallElement.InnerText = $true;
                            $serverElement.AppendChild( $remoteInstallElement ) | Out-Null;
                            $rebootElement = $xml.CreateElement( "Reboot" );
                                $rebootElement.InnerText = $reboot;
                            $serverElement.AppendChild( $rebootElement ) | Out-Null;
                        $crmSetupElement.AppendChild( $serverElement ) | Out-Null;
                    $xml.AppendChild( $crmSetupElement ) | Out-Null;

                    $stringWriter = New-Object System.IO.StringWriter;
                    $xmlWriter = New-Object System.Xml.XmlTextWriter $stringWriter;
                    $xmlWriter.Formatting = "indented";
                    $xml.WriteTo( $xmlWriter );
                    $xmlWriter.Flush();
                    $stringWriter.Flush();

                    $localInstallationScriptBlock = {
                        param( $setupFilePath, $xmlConfig, $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput)

                        $tempFileName = [guid]::NewGuid().Guid;
                        $tempFilePath = "$env:Temp\$tempFileName.xml";

                        Write-Output "$(Get-Date) Saving configuration temporary to $tempFilePath";
                        Set-Content -Path $tempFilePath -Value $xmlConfig;

                        Write-Output "$(Get-Date) Starting $setupFilePath";

                        $installCrmScript = {
                            param( $setupFilePath, $tempFilePath, $logFilePath );

                            Write-Output "Start-Process '$setupFilePath' -ArgumentList '/Q /config $tempFilePath /L $logFilePath' -Wait;";
                            Start-Process "$setupFilePath" -ArgumentList "/Q /config $tempFilePath /L $logFilePath" -Wait;
                        }

                        $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $tempFilePath, $logFilePath;
                        Write-Output "$(Get-Date) Started installation job, log will be saved in $logFilePath";
                        $lastLinesCount = 0;

                        While ( $job.State -ne "Completed" )
                        {
                            Write-Output "$(Get-Date) Waiting until CRM installation job is done, sleeping $logFilePullIntervalInSeconds sec";
                            Start-Sleep $logFilePullIntervalInSeconds;
                            if(($logFilePullToOutput -eq $True) -and ((Test-Path $logFilePath) -eq $True)) {

                                $linesCount    = (Get-Content $logFilePath | Measure-Object -Line).Lines;
                                $newLinesCount = $linesCount - $lastLinesCount;

                                if($newLinesCount -gt 0) {
                                    Write-Output "$(Get-Date) - new logs: $newLinesCount lines";
                                    $lines = Get-Content $logFilePath | Select-Object -First $newLinesCount -Skip $lastLinesCount;

                                    foreach($line in $lines) {
                                        Write-Output $line;
                                    }
                                } else {
                                Write-Output "$(Get-Date) - no new logs";
                                }

                                $lastLinesCount = $linesCount;
                            }
                        }

                        Write-Output "$(Get-Date) Job is complete, output:";
                        Write-Output ( Receive-Job $job );

                        Remove-Job $job;
                        Start-Sleep 10;

                        Write-Output "$(Get-Date) Removing xml configuration file";
                        Remove-Item $tempFilePath;
                    }
                    if([String]::IsNullOrEmpty($logFilePath) -eq $True) {
                        $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
                        $logFilePath = "$env:Temp\CRMInstallationLog_$timeStamp.txt";
                    }
                    Invoke-Command -ScriptBlock $localInstallationScriptBlock `
                        -ArgumentList $setupFilePath, $stringWriter.ToString(), $logFilePath, $logFilePullIntervalInSeconds, $logFilePullToOutput;
                    $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
                    If ( $msCRMRegistryValues ) {
                        $isInstalled = $true;
                        $installedVersion = Get-Dynamics365ServerVersion;
                        if ( $installedVersion -ne $fileVersion ) {
                            $errorMessage = "Another version is already installed: $($installedVersion.ToString())";
                            Write-Output $errorMessage;
                            Throw $errorMessage;
                        }
                        $installedLanguage = Get-Dynamics365ServerLanguage;
                        if ( $installedLanguage -ne $fileLanguageCode ) {
                            $errorMessage = "Another language is already installed: $installedLanguage";
                            Write-Output $errorMessage;
                            Throw $errorMessage;
                        }
                    } else {
                        $isInstalled = $false;
                    }
                    if ( $isInstalled ) {
                        Write-Output "Found Roles: ";
                        $installedRoles = Get-Dynamics365ServerRole;
                        $installedRoles | Write-Output;
                        if ( $ServerRoles ) {
                            $ServerRoles | ForEach-Object {
                                if ( !( $installedRoles -contains $_ -or ( $_ -eq "VssWriter" -and $installedRoles -contains "VssWriterService" ) ) ) {
                                    $errorMessage = "Installation job finished but $_ role is not installed";
                                    Write-Output $errorMessage;
                                    Throw $errorMessage;
                                }
                            }
                        }
                        Write-Output "Installation is finished and verified successfully";
                    } else {
                        if( (Test-Path $logFilePath) -eq $True) {
                            $errorLines = Get-Content $logFilePath | Select-String -Pattern "Error" -SimpleMatch;
                            if($null -ne $errorLines) {
                                "Errors from install log: $logFilePath";
                                foreach($errorLine in $errorLines) {
                                    $errorLine;
                                }
                            }
                        }
                        $errorMessage = "Installation job finished but the product is still not installed";
                        Write-Output $errorMessage;
                        Throw $errorMessage;
                    }
                } else {
                    Write-Output "This product is already installed, skipping";
                }
            } else {
                $errorMessage = "Single language is not found in \LangPacks directory";
                Write-Output $errorMessage;
                Throw $errorMessage;
            }
        } else {
            $errorMessage = "\LangPacks directory is not found";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        $errorMessage = "\SetupServer.exe file is not found";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
}
