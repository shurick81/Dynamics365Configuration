function Expand-Dynamics365Resource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0)]
        [string]
        $ResourcePath,
        [Parameter(Position=1)]
        [string]
        $TargetDirectory
    )
    if ( $resourcePath ) {
        $fileItem = Get-Item $resourcePath;
        if ( $fileItem ) {
            if ( !$fileItem.PSIsContainer ) {
                $directoryPath = $targetDirectory;
                if ( !$directoryPath ) { $directoryPath = Join-Path "." $fileItem.BaseName }
                if ( !( Get-ChildItem $directoryPath -ErrorAction Ignore ) ) {
                    New-Item $directoryPath -ItemType Directory -Force | Out-Null;
                    Write-Output "$(Get-Date) Unpacking $resourcePath to $directoryPath";
                    Start-Process -FilePath $resourcePath -ArgumentList "/extract:$directoryPath /passive /quiet" -Wait -NoNewWindow;
                    Write-Output "$(Get-Date) Finished unpacking";
                } else {
                    Throw "Directory $directoryPath is not empty";
                }
            } else {
                Throw "File $resourcePath is not a file but a directory";
            }
        } else {
            Throw "File $resourcePath is not found";
        }
    } else {
        Write-Debug "Extracting all exe-files"
        Get-Item "./*.exe" | ForEach-Object {
            if ( !$targetDirectory ) { $targetDirectory = "." }
            $subfolderPath = Join-Path $targetDirectory $_.BaseName;
            Expand-Dynamics365Resource $_.FullName -TargetDirectory $subfolderPath;
        }
    }
}
