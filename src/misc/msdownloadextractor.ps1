# Run in pwsh
Install-Module PowerHTML -ErrorAction Stop -Force;
Import-Module -ErrorAction Stop PowerHTML;
Import-Module .\src\Dynamics365Configuration;
$resultDictionary = $Dynamics365Resources;
$htmlDom = ConvertFrom-Html -URI https://support.microsoft.com/en-us/topic/microsoft-dynamics-365-on-premises-cumulative-updates-ed51f905-cf4e-3641-dc7c-afe2b868eeb9;
$sections = $htmlDom.SelectNodes('//section') | ? { $_.GetAttributeValue( "aria-label",'' ).StartsWith( "Cumulative updates available for Microsoft" ) };
$sections.Elements('table').Elements('tbody').Elements('tr').Elements('td').Elements('p').Elements('a').GetAttributeValue('href','') | % {
    if ( $_.StartsWith( "/" ) ) {
        $kbPageUrl = "https://support.microsoft.com$_";
        $htmlDom = ConvertFrom-Html -URI $kbPageUrl;
        $link = $htmlDom.SelectNodes('//a') | ? { $_.GetAttributeValue( "class",'' ) -eq "ocpExternalLink" -and $_.InnerText -ne "Return to Release List" -and $_.InnerText -ne "JOIN MICROSOFT INSIDERS &gt;" };
        $downloadWelcomePageUrl = $link.GetAttributeValue('href','');
        Write-Host "downloadWelcomePageUrl: $downloadWelcomePageUrl";
        $htmlDom = ConvertFrom-Html -URI $downloadWelcomePageUrl;
        $newLocaleSelector = $htmlDom.SelectNodes('//select') | ? { $_.GetAttributeValue("Name",'') -eq "newlocale" };
        if ( $newLocaleSelector ) {
            $newLocaleSelector.Elements('option') | % {
                $_.Attributes | ? { $_.Name -eq 'value' } | % {
                    $selectedLocale = $_.Value;
                    Write-Host $selectedLocale;
                    $downloadConfirmationPageUrl = $downloadWelcomePageUrl.Replace( "en-us", $selectedLocale ).Replace( "/download/details.aspx?id=", "/download/confirmation.aspx?id=" );
                    $htmlDom = ConvertFrom-Html -URI $downloadConfirmationPageUrl;
                    $htmlDom.SelectNodes('//div[@class="multifile-failover-view1"]').Elements('a') | % { $_.GetAttributeValue( "href",'' ) } | % {
                        $resourceUrl = $_;
                        Write-Host "Discovered URL: $resourceUrl";
                        if ( !( $Dynamics365Resources | Get-Member -MemberType NoteProperty | ? { $Dynamics365Resources.( $_.Name ).Url -eq $resourceUrl } ) ) {
                            Write-Host "$resourceUrl is not found in the Dynamics365Resources";
                            $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null;
                            $resourceFileName = $matches[0];

                            $tempDirName = [guid]::NewGuid().Guid;
                            $tempDirPath = "$env:Temp\$tempDirName";
                            $filePath = "$tempDirPath\$resourceFileName";
                            New-Item $tempDirPath -ItemType Directory -Force | Out-Null;

                            $resourceName = $null;
                            if ( $resourceFileName -like "CRM9.?-Server-KB*-*-amd64.exe" ) {
                                Write-Host "$(Get-Date) Downloading $resourceUrl to $filePath";
                                $currentProgressPreference = $ProgressPreference;
                                $ProgressPreference = 'SilentlyContinue';
                                Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
                                $ProgressPreference = $currentProgressPreference;
                                $fileVersion = [version]( Get-Command $filePath ).FileVersionInfo.FileVersion;
                                $fileVersionRaw = ( Get-Command $filePath ).FileVersionInfo.FileVersionRaw;
                                $minorVersion = $fileVersion.Minor;
                                $buildVersionString = [string]$fileVersion.Build;
                                $buildVersionStringPadded = $buildVersionString.PadLeft(2,'0');
                                $language = $resourceFileName.Substring(24,3);
                                $languageTitled = (Get-Culture).TextInfo.ToTitleCase($language.ToLower());
                                $resourceName = "Dynamics365Server9$minorVersion`Update$buildVersionStringPadded$languageTitled";
                                $resourceName;
                            }
                            if ( $resourceFileName -like "CRM9.?-Srs-KB*-*-amd64.exe" ) {
                                Write-Host "$(Get-Date) Downloading $resourceUrl to $filePath";
                                $currentProgressPreference = $ProgressPreference;
                                $ProgressPreference = 'SilentlyContinue';
                                Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
                                $ProgressPreference = $currentProgressPreference;
                                $fileVersion = [version]( Get-Command $filePath ).FileVersionInfo.FileVersion;
                                $fileVersionRaw = ( Get-Command $filePath ).FileVersionInfo.FileVersionRaw;
                                $minorVersion = $fileVersion.Minor;
                                $buildVersionString = [string]$fileVersion.Build;
                                $buildVersionStringPadded = $buildVersionString.PadLeft(2,'0');
                                $language = $resourceFileName.Substring(21,3);
                                $languageTitled = (Get-Culture).TextInfo.ToTitleCase($language.ToLower());
                                $resourceName = "Dynamics365Server9$minorVersion`ReportingExtensionsUpdate$buildVersionStringPadded$languageTitled";
                                $resourceName;
                            }
                            if ( $resourceName ) {
                                $previousHash = ( Get-FileHash $filePath -Algorithm SHA256 ).Hash;
                                Remove-Item $tempDirPath -Recurse -Force;
                                do {
                                    $fileHash = "";
                                    $tempDirName = [guid]::NewGuid().Guid;
                                    $tempDirPath = "$env:Temp\$tempDirName";
                                    $filePath = "$tempDirPath\$resourceFileName";
                                    New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
                                    Write-Host "$(Get-Date) Downloading $resourceUrl to $filePath";
                                    $currentProgressPreference = $ProgressPreference;
                                    $ProgressPreference = 'SilentlyContinue';
                                    Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
                                    if ( Get-Item $filePath ) {
                                        $downloadedBytes += ( Get-Item $filePath ).Length;
                                    }
                                    Write-Host "Total downloaded bytes: $downloadedBytes";
                                    $ProgressPreference = $currentProgressPreference;
                                    Write-Host "$(Get-Date) Calculating hash for $filePath";
                                    $fileHash = ( Get-FileHash $filePath -Algorithm SHA256 ).Hash;
                                    Remove-Item $tempDirPath -Recurse -Force;
                                    $lastMatches = $fileHash -and ( ( $fileHash -eq $previousHash ) -or ( $fileHash -eq $Dynamics365Resources.$resourceName.checksum_sha256 ) );
                                    if ( !$lastMatches ) {
                                        Write-Host "Does not match with either previous or reference checksum: $( $_.Name ) checksum_sha256 is $fileHash";
                                        Write-Host "Repeating download";
                                        Sleep 1;
                                        $previousHash = $fileHash;
                                    }
                                } until ( $lastMatches );

                                $downloadable = New-Object -TypeName PSCustomObject -Property @{URL = $resourceUrl; checksum_sha256 = $fileHash; mediaFileVersion = $fileVersion.ToString()};
                                $resultDictionary | Add-Member -Name $resourceName -Type NoteProperty -Value $downloadable;
                                $resultDictionary | ConvertTo-Json | Set-Content -Path ./src/misc/FileResources.json;
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
