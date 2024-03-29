$resources = $Dynamics365Resources | Get-Member -MemberType NoteProperty;
$resourceCount = $resources.Count;
$resourceCounter = 1;
Write-Host "Starting resource enumeration";
$downloadedBytes = 0;
$resources | % {
    if ( [int]( ( $resourceCounter - 1) / $resourceCount * $numberOfFragments - 0.5 ) -eq $targetFragment ) {
        $resourceName = $_.Name;
        Write-Host "Verifying $resourceName, $resourceCounter of $resourceCount";
        $resourceUrl = $Dynamics365Resources.$resourceName.URL;
        $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $resourceFileName = $matches[0];
        $previousHash = $Dynamics365Resources.$resourceName.checksum_sha256;
        do {
            $lastMatches = $false;
            $fileHash = "";
            $tempDirName = [guid]::NewGuid().Guid;
            $tempDirPath = "$env:Temp\$tempDirName";
            $filePath = "$tempDirPath\$resourceFileName";
            New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
            $currentProgressPreference = $ProgressPreference;
            $ProgressPreference = 'SilentlyContinue';
            Write-Host "Downloading to $filePath";
            Try {
                Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
            } catch {
                Write-Host $_.Exception.Message -ForegroundColor Red;
            }
            if ( Get-Item $filePath ) {
                $downloadedBytes += ( Get-Item $filePath ).Length;
            }
            Write-Host "Total downloaded bytes: $downloadedBytes"
            $ProgressPreference = $currentProgressPreference;
            if ( Test-Path $filePath ) {
                $fileHash = ( Get-FileHash $filePath -Algorithm SHA256 ).Hash;
                Start-Sleep 20;
                Remove-Item $tempDirPath -Recurse -Force;
                $lastMatches = $fileHash -and ( ( $fileHash -eq $previousHash ) -or ( $fileHash -eq $Dynamics365Resources.$resourceName.checksum_sha256 ) );
                if ( !$lastMatches ) {
                    Write-Host "Does not match with either previous or reference checksum: $resourceName checksum_sha256 is $fileHash";
                    Write-Host "Repeating download`r";
                    $previousHash = $fileHash;
                }
            }
        } until ( $lastMatches )
        if ( $Dynamics365Resources.$resourceName.checksum_sha256 -ne $fileHash ) {
            Write-Host "Incorrect data in module: $resourceName checksum_sha256 is $fileHash";
            Exit 1;
        }
    }
    $resourceCounter++;
}
