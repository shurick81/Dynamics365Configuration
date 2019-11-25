Try {
    $resources = $Dynamics365Resources | Get-Member -MemberType NoteProperty;
    $resourceCount = $resources.Count;
    $resourceCounter = 0;
    Write-Host "Starting resource enumeration";
    $resources | % {
        $resourceName = $_.Name;
        Write-Host "Verifying $resourceName, $resourceCounter of $resourceCount";
        $resourceUrl = $Dynamics365Resources.$resourceName.URL;
        $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $resourceFileName = $matches[0];
        $previousHash = $Dynamics365Resources.$resourceName.Checksum;
        do {
            $fileHash = "";
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
            $lastMatches = $fileHash -and ( ( $fileHash -eq $previousHash ) -or ( $fileHash -eq $Dynamics365Resources.$resourceName.Checksum ) );
            if ( !$lastMatches ) {
                Write-Host "Does not match with either previous or reference checksum: $resourceName checksum is $fileHash";
                Write-Host "Repeating download`r";
                $previousHash = $fileHash;
            }
        } until ( $lastMatches )
        if ( $Dynamics365Resources.$resourceName.Checksum -ne $fileHash ) {
            Write-Host "Incorrect data in module: $resourceName checksum is $fileHash";
            Exit 1;
        }
        $resourceCounter++;
    }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
