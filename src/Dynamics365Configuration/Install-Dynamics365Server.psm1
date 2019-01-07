function Install-Dynamics365Server {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $MediaDir,
        [Parameter(Mandatory=$true)]
        [string]
        $LicenseKey,
        [Parameter(Mandatory=$true)]
        [string]
        $InstallDir,
        [Parameter(Mandatory=$true)]
        [switch]
        $CreateDatabase,
        [Parameter(Mandatory=$true)]
        [string]
        $SqlServer,
        [Parameter(Mandatory=$true)]
        [string]
        $PrivUserGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $SQLAccessGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $UserGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $ReportingGroup,
        [Parameter(Mandatory=$true)]
        [string]
        $PrivReportingGroup,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $CrmServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $DeploymentServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $SandboxServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $VSSWriterServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $AsyncServiceAccount,
        [Parameter(Mandatory=$true)]
        [pscredential]
        $MonitoringServiceAccount,
        [Parameter(Mandatory=$true)]
        [switch]
        $CreateWebSite,
        [Parameter(Mandatory=$true)]
        [int]
        $WebSitePort,
        [Parameter(Mandatory=$true)]
        [string]
        $WebSiteUrl,
        [string]
        $IncomingExchangeServer,
        [Parameter(Mandatory=$true)]
        [string]
        $Organization,
        [Parameter(Mandatory=$true)]
        [string]
        $OrganizationUniqueName,
        [Parameter(Mandatory=$true)]
        [string]
        $BaseISOCurrencyCode,
        [Parameter(Mandatory=$true)]
        [string]
        $BaseCurrencyName,
        [Parameter(Mandatory=$true)]
        [string]
        $BaseCurrencySymbol,
        [Parameter(Mandatory=$true)]
        [int]
        $BaseCurrencyPrecision,
        [Parameter(Mandatory=$true)]
        [string]
        $OrganizationCollation,
        [Parameter(Mandatory=$true)]
        [string]
        $ReportingUrl,
        [switch]
        $SQM = $false,
        [switch]
        $MUOptin = $false,
        [switch]
        $Reboot = $false,
        [pscredential]
        $InstallAccount
    )
    $setupFilePath = "$mediaDir\SetupServer.exe";
    $fileVersion = ( Get-Command $setupFilePath ).FileVersionInfo.FileVersionRaw.ToString();
    Write-Host "Version of software to be installed: $fileVersion";
    $testScriptBlock = {
        try {
            Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
            if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
                $CrmOrganization = Get-CrmOrganization;
                $CrmOrganization.Version;
            } else {
                "Could not load Microsoft.Crm.PowerShell PSSnapin";
            }
        } catch {
            Write-Host "$(Get-Date) Caught an exception: $($_.Exception.Message)";
            $_.Exception.Message;
        }
    }
    if ( $installAccount )
    {
        $testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP;
    } else {
        $testResponse = Invoke-Command -ScriptBlock $testScriptBlock;
    }
    $productDetected = $null;
    if ( $testResponse.StartsWith( "9." ) -or $testResponse.StartsWith( "8." ) ) {
        $productDetected = $testResponse;
    }
    # Starting installation only when no Dynamics products is installed.
    if ( !$productDetected ) {
        $xml = [xml]"";
        $crmSetupElement = $xml.CreateElement( "CRMSetup" );
            $serverElement = $xml.CreateElement( "Server" );
                $patchElement = $xml.CreateElement( "Patch" );
                    $patchElement.SetAttribute( "Update", $false ) | Out-Null;
                $serverElement.AppendChild( $patchElement ) | Out-Null;
                $licenseKeyElement = $xml.CreateElement( "LicenseKey" );
                    $licenseKeyElement.InnerText = $licenseKey;
                $serverElement.AppendChild( $licenseKeyElement ) | Out-Null;
                $installDirElement = $xml.CreateElement( "InstallDir" );
                    $installDirElement.InnerText = $installDir;
                $serverElement.AppendChild( $installDirElement ) | Out-Null;
                $databaseElement = $xml.CreateElement( "Database" );
                    $databaseElement.SetAttribute( "create", $createDatabase ) | Out-Null;
                $serverElement.AppendChild( $databaseElement ) | Out-Null;
                $SQLServerElement = $xml.CreateElement( "SqlServer" );
                    $SQLServerElement.InnerText = $SQLServer;
                $serverElement.AppendChild( $SQLServerElement ) | Out-Null;
                $groupsElement = $xml.CreateElement( "Groups" );
                    $groupsElement.SetAttribute( "autogroupmanagementoff", $false ) | Out-Null;
                    $privUserGroupElement = $xml.CreateElement( "PrivUserGroup" );
                        $privUserGroupElement.InnerText = $privUserGroup;
                    $groupsElement.AppendChild( $privUserGroupElement ) | Out-Null;
                    $SQLAccessGroupElement = $xml.CreateElement( "SQLAccessGroup" );
                        $SQLAccessGroupElement.InnerText = $SQLAccessGroup;
                    $groupsElement.AppendChild( $SQLAccessGroupElement ) | Out-Null;
                    $userGroupElement = $xml.CreateElement( "UserGroup" );
                        $userGroupElement.InnerText = $userGroup;
                    $groupsElement.AppendChild( $userGroupElement ) | Out-Null;
                    $reportingGroupElement = $xml.CreateElement( "ReportingGroup" );
                        $reportingGroupElement.InnerText = $reportingGroup;
                    $groupsElement.AppendChild( $reportingGroupElement ) | Out-Null;
                    $privReportingGroupElement = $xml.CreateElement( "PrivReportingGroup" );
                        $privReportingGroupElement.InnerText = $privReportingGroup;
                    $groupsElement.AppendChild( $privReportingGroupElement ) | Out-Null;
                $serverElement.AppendChild( $groupsElement ) | Out-Null;
                $CRMServiceAccountElement = $xml.CreateElement( "CrmServiceAccount" );
                    $CRMServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                        $serviceAccountLoginElement.InnerText = $CRMServiceAccount.UserName;
                    $CRMServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                        $serviceAccountPasswordElement.InnerText = $CRMServiceAccount.GetNetworkCredential().Password;
                    $CRMServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                $serverElement.AppendChild( $CRMServiceAccountElement ) | Out-Null;
                $deploymentServiceAccountElement = $xml.CreateElement( "DeploymentServiceAccount" );
                    $deploymentServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                        $serviceAccountLoginElement.InnerText = $deploymentServiceAccount.UserName;
                    $deploymentServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                        $serviceAccountPasswordElement.InnerText = $deploymentServiceAccount.GetNetworkCredential().Password;
                    $deploymentServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                $serverElement.AppendChild( $deploymentServiceAccountElement ) | Out-Null;
                $sandboxServiceAccountElement = $xml.CreateElement( "SandboxServiceAccount" );
                    $sandboxServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                        $serviceAccountLoginElement.InnerText = $sandboxServiceAccount.UserName;
                    $sandboxServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                        $serviceAccountPasswordElement.InnerText = $sandboxServiceAccount.GetNetworkCredential().Password;
                    $sandboxServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                $serverElement.AppendChild( $sandboxServiceAccountElement ) | Out-Null;
                $VSSWriterServiceAccountElement = $xml.CreateElement( "VSSWriterServiceAccount" );
                    $VSSWriterServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                        $serviceAccountLoginElement.InnerText = $VSSWriterServiceAccount.UserName;
                    $VSSWriterServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                        $serviceAccountPasswordElement.InnerText = $VSSWriterServiceAccount.GetNetworkCredential().Password;
                    $VSSWriterServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                $serverElement.AppendChild( $VSSWriterServiceAccountElement ) | Out-Null;
                $asyncServiceAccountElement = $xml.CreateElement( "AsyncServiceAccount" );
                    $asyncServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                        $serviceAccountLoginElement.InnerText = $asyncServiceAccount.UserName;
                    $asyncServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                        $serviceAccountPasswordElement.InnerText = $asyncServiceAccount.GetNetworkCredential().Password;
                    $asyncServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                $serverElement.AppendChild( $asyncServiceAccountElement ) | Out-Null;
                $monitoringServiceAccountElement = $xml.CreateElement( "MonitoringServiceAccount" );
                    $monitoringServiceAccountElement.SetAttribute( "type", "DomainUser" ) | Out-Null;
                    $serviceAccountLoginElement = $xml.CreateElement( "ServiceAccountLogin" );
                        $serviceAccountLoginElement.InnerText = $monitoringServiceAccount.UserName;
                    $monitoringServiceAccountElement.AppendChild( $serviceAccountLoginElement ) | Out-Null;
                    $serviceAccountPasswordElement = $xml.CreateElement( "ServiceAccountPassword" );
                        $serviceAccountPasswordElement.InnerText = $monitoringServiceAccount.GetNetworkCredential().Password;
                    $monitoringServiceAccountElement.AppendChild( $serviceAccountPasswordElement ) | Out-Null;
                $serverElement.AppendChild( $monitoringServiceAccountElement ) | Out-Null;
                $webSiteUrlElement = $xml.CreateElement( "WebsiteUrl" );
                    $webSiteUrlElement.SetAttribute( "create", $createWebSite ) | Out-Null;
                    $webSiteUrlElement.SetAttribute( "port", $webSitePort ) | Out-Null;
                    $webSiteUrlElement.InnerText = $webSiteUrl;
                $serverElement.AppendChild( $webSiteUrlElement ) | Out-Null;
                $emailElement = $xml.CreateElement( "Email" );
                    $incomingExchangeServerElement = $xml.CreateElement( "IncomingExchangeServer" );
                        $incomingExchangeServerElement.SetAttribute( "name", $incomingExchangeServer ) | Out-Null;
                    $emailElement.AppendChild( $incomingExchangeServerElement ) | Out-Null;
                $serverElement.AppendChild( $emailElement ) | Out-Null;
                $organizationUniqueNameElement = $xml.CreateElement( "OrganizationUniqueName" );
                    $organizationUniqueNameElement.InnerText = $organizationUniqueName;
                $serverElement.AppendChild( $organizationUniqueNameElement ) | Out-Null;
                $organizationElement = $xml.CreateElement( "Organization" );
                    $organizationElement.InnerText = $organization;
                $serverElement.AppendChild( $organizationElement ) | Out-Null;
                $baseCurrencyElement = $xml.CreateElement( "basecurrency" );
                    $baseCurrencyElement.SetAttribute( "isocurrencycode", $baseISOCurrencyCode ) | Out-Null;
                    $baseCurrencyElement.SetAttribute( "currencyname", $baseCurrencyName ) | Out-Null;
                    $baseCurrencyElement.SetAttribute( "currencysymbol", $baseCurrencySymbol ) | Out-Null;
                    $baseCurrencyElement.SetAttribute( "currencyprecision", $baseCurrencyPrecision ) | Out-Null;
                $serverElement.AppendChild( $baseCurrencyElement ) | Out-Null;
                $organizationCollationElement = $xml.CreateElement( "OrganizationCollation" );
                    $organizationCollationElement.InnerText = $organizationCollation;
                $serverElement.AppendChild( $organizationCollationElement ) | Out-Null;
                $reportingElement = $xml.CreateElement( "Reporting" );
                    $reportingElement.SetAttribute( "URL", $ReportingUrl ) | Out-Null;
                $serverElement.AppendChild( $reportingElement ) | Out-Null;
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
                $launchReportingExtensionsSetupElement = $xml.CreateElement( "LaunchReportingExtensionsSetup" );
                    $launchReportingExtensionsSetupElement.InnerText = $true;
                $serverElement.AppendChild( $launchReportingExtensionsSetupElement ) | Out-Null;
            $crmSetupElement.AppendChild( $serverElement ) | Out-Null;
        $xml.AppendChild( $crmSetupElement ) | Out-Null;

        $stringWriter = New-Object System.IO.StringWriter;
        $xmlWriter = New-Object System.Xml.XmlTextWriter $stringWriter;
        $xmlWriter.Formatting = "indented";
        $xml.WriteTo( $xmlWriter );
        $xmlWriter.Flush();
        $stringWriter.Flush();

        $localInstallationScriptBlock = {
            param( $setupFilePath, $xmlConfig )
            $tempFileName = [guid]::NewGuid().Guid;
            $tempFilePath = "$env:Temp\$tempFileName.xml";
            Write-Host "$(Get-Date) Saving configuration temporary to $tempFilePath";
            Set-Content -Path $tempFilePath -Value $xmlConfig;
            Write-Host "$(Get-Date) Starting $setupFilePath";
            $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
            $logFileName = "$env:Temp\CRMInstallationLog_$timeStamp.txt";
            $installCrmScript = {
                param( $setupFilePath, $tempFilePath, $logFileName );
                Write-Host "Start-Process '$setupFilePath' -ArgumentList '/Q /config $tempFilePath /L $logFileName' -Wait;";
                Start-Process "$setupFilePath" -ArgumentList "/Q /config $tempFilePath /L $logFileName" -Wait;
            }
            $job = Start-Job -ScriptBlock $installCrmScript -ArgumentList $setupFilePath, $tempFilePath, $logFileName;
            Write-Host "$(Get-Date) Started installation job, log will be saved in $logFileName";
            While ( $job.State -ne "Completed" )
            {
                Write-Host "$(Get-Date) Waiting until CRM installation job is done";
                Sleep 60;
            }
            Write-Host "$(Get-Date) Job is complete, output:";
            Write-Output ( Receive-Job $job );
            Remove-Job $job;
            Remove-Item $tempFilePath;
        }
        if ( $installAccount )
        {
            Invoke-Command -ScriptBlock $localInstallationScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP -ArgumentList $setupFilePath, $stringWriter.ToString();
        } else {
            Invoke-Command -ScriptBlock $localInstallationScriptBlock -ArgumentList $setupFilePath, $stringWriter.ToString();
        }
        $testScriptBlock = {
            try {
                Add-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore
                if ( Get-PSSnapin Microsoft.Crm.PowerShell -ErrorAction Ignore ) {
                    $CrmOrganization = Get-CrmOrganization;
                    $CrmOrganization.Version;
                } else {
                    "Could not load Microsoft.Crm.PowerShell PSSnapin";
                }
            } catch {
                $_.Exception.Message;
            }
        }
        if ( $installAccount )
        {
            $testResponse = Invoke-Command -ScriptBlock $testScriptBlock $env:COMPUTERNAME -Credential $installAccount -Authentication CredSSP;
        } else {
            $testResponse = Invoke-Command -ScriptBlock $testScriptBlock;
        }
        if ( $testResponse -eq $fileVersion ) {
            Write-Host "Installation is finished and verified successfully";
        } else {
            Write-Host "Installation job finished but the product is still not installed. Current product version installed is '$testResponse'";
            Throw "Installation job finished but the product is still not installed. Current product version installed is '$testResponse'";
        }
    } else {
        Write-Host "Product version '$testResponse' is already installed, skipping"
    }
}
