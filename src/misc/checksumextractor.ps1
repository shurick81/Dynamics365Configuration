$resultDictionary = $Dynamics365Resources;
$downloadedBytes = 0;
$Dynamics365Resources | Get-Member -MemberType NoteProperty | % {
    if ( !$Dynamics365Resources.( $_.Name ).Checksum ) {
        $previousHash = $Dynamics365Resources.( $_.Name ).Checksum;
        $resourceUrl = $Dynamics365Resources.( $_.Name ).URL;
        $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $resourceFileName = $matches[0];
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
            Write-Host "Total downloaded bytes: $downloadedBytes"
            $ProgressPreference = $currentProgressPreference;
            Write-Host "$(Get-Date) Calculating hash for $filePath";
            $fileHash = ( Get-FileHash $filePath -Algorithm SHA1 ).Hash;
            Remove-Item $tempDirPath -Recurse -Force;
            $lastMatches = $fileHash -and ( ( $fileHash -eq $previousHash ) -or ( $fileHash -eq $Dynamics365Resources.$resourceName.Checksum ) );
            if ( !$lastMatches ) {
                Write-Host "Does not match with either previous or reference checksum: $( $_.Name ) checksum is $fileHash";
                Write-Host "Repeating download";
                Sleep 1;
                $previousHash = $fileHash;
            }
        } until ( $lastMatches )
        $resultDictionary.( $_.Name ).Checksum = $fileHash;
        $resultDictionary | ConvertTo-Json | Set-Content -Path C:/projects/Dynamics365Configuration/src/misc/FileResources.json
    } else {
        Write-Host "Resource has checksum specified";
    }
}
