$Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
    $resourceName = $_.Name;
    Write-Host "Comparing $resourceName"
    $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
    $Dynamics365Resources | Get-Member -MemberType NoteProperty | ? { $_.Name -ne $resourceName } | % {
        if ( $Dynamics365Resources.( $_.Name ).URL -eq $resourceUrl ) {
            Write-Host "Both $resourceName and $($_.Name) have the same URL. Test not OK.";
            Exit 1;
        }
    }
}
Write-Host "Test OK"
Exit 0;
