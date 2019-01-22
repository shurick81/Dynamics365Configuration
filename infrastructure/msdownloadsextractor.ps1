# Obtains URLs for all languages of any microsoft download
$baseUrl = "https://www.microsoft.com/en-us/download/details.aspx?id=57478"
$ie = new-object -ComObject "InternetExplorer.Application"
$ie.visible = $true;
$ie.navigate( $baseUrl );
while( $ie.Busy ) { Start-Sleep 1 }
Sleep 1;
$doc = $ie.Document;
$newLocaleSelector = $doc.getElementsByTagName("select") | ? { $_.Name -eq "newlocale" }
if ( $newLocaleSelector ) {
    $elements = $newLocaleSelector.outerHTML;
    ([xml]$elements).ChildNodes.ChildNodes.Value | % {
        $locale = $_;
        Write-Host "Extracting URL for $locale"
        $ie.navigate( $baseUrl.Replace( "en-us", $locale ).Replace( "/download/details.aspx?id=", "/download/confirmation.aspx?id=" ) );
        Start-Sleep 2
        while( $ie.Busy ) { Start-Sleep 1 }
        Start-Sleep 3
        $doc = $ie.Document;
        $db = $doc.getElementsByTagName("a") | ? { $_.className -eq "mscom-link mscom-popup-link failoverLink multi" }
        if ( $db ) {
            $db.click();
            Sleep 5;
            $doc = $ie.Document;
            $doc.getElementsByTagName("td") | ? { $_.className -eq "multifile-failover-url" } | % {
                $_.getElementsByTagName("a") | ? { $_.className -eq "mscom-link" } | select href | % {
                    return "$locale|$_";
                }
            }
        } else {
            $doc.getElementsByTagName("a") | ? { $_.className -eq "mscom-link failoverLink" } | select href | % {
                return "$locale|$_";
            }
        }
    }
}
$ie.quit();
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie);
