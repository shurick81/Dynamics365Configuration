$resources = $Dynamics365Resources | Get-Member -MemberType NoteProperty;
$resourceCount = $resources.Count;
$resourceCounter = 0;
Write-Host "Starting resource enumeration";
$resources | % {
    $resourceName = $_.Name;
    Write-Progress -Activity "Verifying $resourceName" -PercentComplete ( ( $resourceCounter + 1 ) / ( $resourceCount + 1 ) * 100 );
    $resourceUrl = $Dynamics365Resources.$resourceName.URL;
    $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
    $resourceFileName = $matches[0];
    $previousHash = $Dynamics365Resources.$resourceName.Checksum;
    do {
        $tempDirName = [guid]::NewGuid().Guid;
        $tempDirPath = "$env:Temp\$tempDirName";
        $filePath = "$tempDirPath\$resourceFileName";
        New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
        $currentProgressPreference = $ProgressPreference;
        $ProgressPreference = 'SilentlyContinue';
        Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
        $ProgressPreference = $currentProgressPreference;
        $fileHash = ( Get-FileHash $filePath -Algorithm SHA1 ).Hash;
        Start-Sleep 20;
        Remove-Item $tempDirPath -Recurse -Force;
        $lastMatches = ( $fileHash -eq $previousHash ) -or ( $fileHash -eq $Dynamics365Resources.$resourceName.Checksum );
        if ( !$lastMatches ) {
            Write-Host "Does not match with either previous or reference checksum: $resourceName checksum is $fileHash";
            Write-Host "Repeating download";
            $previousHash = $fileHash;
        }
    } until ( $lastMatches )
    if ( $Dynamics365Resources.$resourceName.Checksum -ne $fileHash ) {
        Write-Host "Incorrect data in module: $resourceName checksum is $fileHash";
    }
    $resourceCounter++;
}
