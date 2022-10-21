$resources = $Dynamics365Resources | Get-Member -MemberType NoteProperty;
$resourceCount = $resources.Count;
$resourceCounter = 1;
Write-Host "Starting resource enumeration";
$downloadedBytes = 0;
$resources | % {
    $resourceName = $_.Name;
    Write-Progress -Activity "Verifying $resourceName" -PercentComplete ( $resourceCounter / ( $resourceCount + 1 ) * 100 );
    $resourceUrl = $Dynamics365Resources.$resourceName.URL;
    $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
    $resourceFileName = $matches[0];
    $previousHash = $Dynamics365Resources.$resourceName.checksum_sha256;
    do {
        $fileHash = "";
        $tempDirName = [guid]::NewGuid().Guid;
        $tempDirPath = "$env:Temp\$tempDirName";
        $filePath = "$tempDirPath\$resourceFileName";
        New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
        $currentProgressPreference = $ProgressPreference;
        $ProgressPreference = 'SilentlyContinue';
        Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
        if ( Get-Item $filePath ) {
            $downloadedBytes += ( Get-Item $filePath ).Length;
        }
        Write-Host "Total downloaded bytes: $downloadedBytes"
        $ProgressPreference = $currentProgressPreference;
        $fileHash = ( Get-FileHash $filePath -Algorithm SHA256 ).Hash;
        Start-Sleep 20;
        Remove-Item $tempDirPath -Recurse -Force;
        $lastMatches = $fileHash -and ( ( $fileHash -eq $previousHash ) -or ( $fileHash -eq $Dynamics365Resources.$resourceName.checksum_sha256 ) );
        if ( !$lastMatches ) {
            Write-Host "Does not match with either previous or reference checksum_sha256: $resourceName checksum_sha256 is $fileHash";
            Write-Host "Repeating download";
            $previousHash = $fileHash;
        }
    } until ( $lastMatches )
    if ( $Dynamics365Resources.$resourceName.checksum_sha256 -ne $fileHash ) {
        Write-Host "Incorrect data in module: $resourceName checksum_sha256 is $fileHash";
    }
    $resourceCounter++;
}
