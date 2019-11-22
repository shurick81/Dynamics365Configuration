$resourceUrls = $Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
    $Dynamics365Resources.( $_.Name ).URL
}
$resourceUrlsWithoutDuplicates = $resourceUrls | Select-Object -Unique;
if ( $resourceUrlsWithoutDuplicates.Count -ne $resourceUrls.Count ) {
    Write-Host "resourceUrlsWithoutDuplicates.Count is $($resourceUrlsWithoutDuplicates.Count) while resourceUrls.Count is $($resourceUrls.Count)";
    Exit 1;
}
Write-Host "Test OK"
Exit 0;
