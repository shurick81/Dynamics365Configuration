$totalSize = 0;
$Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
    $resourceName = $_.Name;
    $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
    Write-Host "Verifying $resourceName"
    $attemptsLeft = 10;
    Do {
        $response = $null;
        $response = Invoke-WebRequest $resourceUrl -UseBasicParsing -Method Head;
        if ( $response ) {
            if ( $response.StatusCode -eq "200" ) {
                Write-Host "Response OK";
                $totalSize = $totalSize + $response.Headers.'Content-Length';
            } else {
                Write-Host "Response is not OK";
                Start-Sleep 1;
            }
        } else {
            Write-Host "Request is not OK";
            Start-Sleep 1;
        }
        $attemptsLeft--;
    } until ( ( $response.StatusCode -eq "200" ) -or ( $attemptsLeft -eq 0 ) )
    if ( $response.StatusCode -ne "200" ) {
        Write-Host "Test is not OK";
        Exit 1;
    }
}
Write-Host "Test OK";
Write-Host "Total file size is $totalSize";
Exit 0;
