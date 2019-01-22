$resultDictionary = $Dynamics365Resources;
$Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
    if ( !$Dynamics365Resources.( $_.Name ).Checksum ) {
        $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
        $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $resourceFileName = $matches[0];
        $tempDirName = [guid]::NewGuid().Guid;
        $tempDirPath = "$env:Temp\$tempDirName";
        $filePath = "$tempDirPath\$resourceFileName";
        New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
        Write-Host "$(Get-Date) Downloading $resourceUrl to $filePath";
        $currentProgressPreference = $ProgressPreference;
        $ProgressPreference = 'SilentlyContinue';
        Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
        $ProgressPreference = $currentProgressPreference;
        Write-Host "$(Get-Date) Calculating cache for $filePath";
        $fileHash = ( Get-FileHash $filePath -Algorithm SHA1 ).Hash;
        Remove-Item $tempDirPath -Recurse -Force;
        $resultDictionary.( $_.Name ).Checksum = $fileHash;
        #$resultDictionary | ConvertTo-Json
        #Exit 0;
    } else {
        Write-Host "Resource has checksum specified";
    }
}
$resultDictionary | ConvertTo-Json