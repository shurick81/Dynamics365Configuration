# Run in pwsh
Install-Module PowerHTML -ErrorAction Stop -Force
Import-Module -ErrorAction Stop PowerHTML
Import-Module .\src\Dynamics365Configuration
$resultDictionary = $Dynamics365Resources;
$htmlDom = ConvertFrom-Html -URI https://support.microsoft.com/en-us/topic/microsoft-dynamics-365-on-premises-cumulative-updates-ed51f905-cf4e-3641-dc7c-afe2b868eeb9
$sections = $htmlDom.SelectNodes('//section') | ? { $_.GetAttributeValue( "aria-label",'' ).StartsWith( "Cumulative updates available for Microsoft" ) }
$sections.Elements('table').Elements('tbody').Elements('tr').Elements('td').Elements('p').Elements('a').GetAttributeValue('href','') | % {
    if ( $_.StartsWith( "/" ) ) {
        $htmlDom = ConvertFrom-Html -URI https://support.microsoft.com$_
        $link = $htmlDom.SelectNodes('//a') | ? { $_.GetAttributeValue( "class",'' ) -eq "ocpExternalLink" }
        $downloadWelcomePageUrl = $link.GetAttributeValue('href','')
        $htmlDom = ConvertFrom-Html -URI $downloadWelcomePageUrl
        $newLocaleSelector = $htmlDom.SelectNodes('//select') | ? { $_.GetAttributeValue("Name",'') -eq "newlocale" }
        if ( $newLocaleSelector ) {
            $newLocaleSelector.Elements('option') | % {
                $_.Attributes | ? { $_.Name -eq 'value' } | % {
                    $selectedLocale = $_.Value;
                    Write-Host $selectedLocale;
                    $downloadConfirmationPageUrl = $downloadWelcomePageUrl.Replace( "en-us", $selectedLocale ).Replace( "/download/details.aspx?id=", "/download/confirmation.aspx?id=" );
                    $htmlDom = ConvertFrom-Html -URI $downloadConfirmationPageUrl;
                    $htmlDom.SelectNodes('//div[@class="multifile-failover-view1"]').Elements('a') | % { $_.GetAttributeValue( "href",'' ) } | % {
                        $discoveredUrl = $_;
                        Write-Host "Discovered URL: $discoveredUrl";
                        if ( !( $Dynamics365Resources | Get-Member -MemberType NoteProperty | ? { $Dynamics365Resources.( $_.Name ).Url -eq $discoveredUrl } ) ) {
                            Write-Host "$discoveredUrl is not found in the Dynamics365Resources";
                            $discoveredUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null;
                            $fileName = $matches[0];
                            Write-Host "File name is $fileName";
                            if ( $env:TEMP ) {
                                $tempFileName = "$env:TEMP\$fileName";
                            } else {
                                $tempFileName = "/tmp/$fileName";
                            }
                            $resourceName = $null;
                            if ( $fileName -like "CRM9.?-Server-KB*-*-amd64.exe" ) {
                                $currentProgressPreference = $ProgressPreference;
                                $ProgressPreference = 'SilentlyContinue';
                                Invoke-WebRequest -Uri $discoveredUrl -OutFile $tempFileName;
                                $ProgressPreference = $currentProgressPreference;
                                $fileVersion = [version]( Get-Command $tempFileName ).FileVersionInfo.FileVersion;
                                $fileVersionRaw = ( Get-Command $tempFileName ).FileVersionInfo.FileVersionRaw;
                                $minorVersion = $fileVersion.Minor;
                                $buildVersionString = [string]$fileVersion.Build;
                                $buildVersionStringPadded = $buildVersionString.PadLeft(2,'0');
                                $language = $fileName.Substring(24,3);
                                $languageTitled = (Get-Culture).TextInfo.ToTitleCase($language.ToLower());
                                $resourceName = "Dynamics365Server9$minorVersion`Update$buildVersionStringPadded$languageTitled";
                                $resourceName;
                            }
                            if ( $fileName -like "CRM9.?-Srs-KB*-*-amd64.exe" ) {
                                $currentProgressPreference = $ProgressPreference;
                                $ProgressPreference = 'SilentlyContinue';
                                Invoke-WebRequest -Uri $discoveredUrl -OutFile $tempFileName;
                                $ProgressPreference = $currentProgressPreference;
                                $fileVersion = [version]( Get-Command $tempFileName ).FileVersionInfo.FileVersion;
                                $fileVersionRaw = ( Get-Command $tempFileName ).FileVersionInfo.FileVersionRaw;
                                $minorVersion = $fileVersion.Minor;
                                $buildVersionString = [string]$fileVersion.Build;
                                $buildVersionStringPadded = $buildVersionString.PadLeft(2,'0');
                                $language = $fileName.Substring(21,3);
                                $languageTitled = (Get-Culture).TextInfo.ToTitleCase($language.ToLower());
                                $resourceName = "Dynamics365Server9$minorVersion`ReportingExtensionsUpdate$buildVersionStringPadded$languageTitled";
                                $resourceName;
                            }
                            if ( $resourceName ) {
                                $fileHash = ( Get-FileHash $tempFileName -Algorithm SHA1 ).Hash;
                                $downloadable = New-Object -TypeName PSCustomObject -Property @{URL = $discoveredUrl; checksum = $fileHash; mediaFileVersion = $fileVersion.ToString()}
                                $resultDictionary | Add-Member -Name $resourceName -Type NoteProperty -Value $downloadable;
                                Remove-Item $tempFileName;
                                $resultDictionary | ConvertTo-Json | Set-Content -Path ./src/misc/FileResources.json
                            } else {
                                Write-Host "File name does not match the patterns";
                            }
                        }
                    }
                }
            }
        }
    }
}
