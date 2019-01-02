function DownloadAndUnpack-Dynamics365Resource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,
        Position=0)]
        [string]
        $ResourceUrl,
        [Parameter(Mandatory=$true,
        Position=1)]
        [string]
        $DirectoryPath,
        [Parameter(Mandatory=$false,
        Position=2)]
        [string]
        $ExpectedFileChecksum
    )
    if ( !( Get-ChildItem $directoryPath -ErrorAction Ignore ) ) {
        New-Item $directoryPath -ItemType Directory -Force | Out-Null;
        $resourceUrl -match '[^/\\&\?]+\.\w{3,4}(?=([\?&].*$|$))' | Out-Null
        $resourceFileName = $matches[0];
        $resourceFileName -match '\.[A-Za-z0-9]+$' | Out-Null
        if ( ( $matches[0] -eq ".exe" ) -and ( $resourceFileName -ne "vcredist_x64.exe" ) )
        {
            $tempDirName = [guid]::NewGuid().Guid;
            $tempDirPath = "$env:Temp\$tempDirName";
            $filePath = "$tempDirPath\$resourceFileName";
            New-Item $tempDirPath -ItemType Directory -Force | Out-Null;
            Write-Host "Downloading $resourceUrl to $filePath";
            $currentProgressPreference = $ProgressPreference;
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
            $ProgressPreference = $currentProgressPreference;
            if ( Get-Item $filePath )
            {
                $fileHash = ( Get-FileHash $filePath -Algorithm SHA1 ).Hash;
                Write-Host "Hash of the downloaded file: $fileHash";
                if ( ( $fileHash -eq $expectedFileChecksum ) -or !$expectedFileChecksum )
                {
                    Write-Host "Unpacking $filePath to $directoryPath";
                    Start-Process -FilePath $filePath -ArgumentList "/extract:$directoryPath /passive /quiet" -Wait -NoNewWindow;
                    Remove-Item $filePath;
                } else {
                    Write-Host "Hash does not match $expectedFileChecksum";
                    Remove-Item $filePath;
                }
            }
        } else {
            $filePath = "$directoryPath\$resourceFileName";
            Write-Host "Downloading $resourceUrl to $filePath";
            $currentProgressPreference = $ProgressPreference;
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $resourceUrl -OutFile $filePath;
            $ProgressPreference = $currentProgressPreference;
            if ( Get-Item $filePath )
            {
                $fileHash = ( Get-FileHash $filePath -Algorithm SHA1 ).Hash;
                Write-Host "Hash of the downloaded file: $fileHash";
                if ( ( $fileHash -eq $expectedFileChecksum ) -or !$expectedFileChecksum )
                { } else {
                    Write-Host "Hash does not match $expectedFileChecksum";
                    Remove-Item $filePath;
                }
            }
        }
    } else {
        Write-Host "The target directory is not empty. Skipped downloading."
    }
}
