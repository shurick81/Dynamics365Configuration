$Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
    $resourceName = $_.Name;
    $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
    Write-Host "Verifying $resourceName"
    $response = $null;
    $response = Invoke-WebRequest $resourceUrl -UseBasicParsing -Method Head
    if ( $response ) {
        if ( $response.StatusCode -eq "200" ) {
            Write-Host "Response OK"
        } else {
            Write-Host "Response is not OK, test is not OK"
            Exit 1;
        }
    } else {
        Write-Host "Test is not OK"
        Exit 1;
    }
}
Write-Host "Test OK"
Exit 0;

