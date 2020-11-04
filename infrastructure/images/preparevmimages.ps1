param(
    [Parameter(Mandatory=$true,Position=1)]
    [string[]]
    $ImageNames
)

$startProcessingMoment = Get-Date;
$imageNames | % {
    $imageName = $_;
    $retriesLimit = 3;
    $retriesCounter = 0;
    $jobDone = $false;
    Do {
        $retriesCounter++;
        Write-Host "$(Get-Date) Starting retry $retriesCounter of $retriesLimit";
        Write-Host "$(Get-Date) Checking $imageName image";
        $existingImages = vagrant box list | ? { $_ -like "$imageName *" };
        if ( !$existingImages ) {
            if ( Get-Item "output-*-iso" -ErrorAction Ignore ) {
                Write-Host "$(Get-Date) Found current output directory(s), now removing";
                Get-Item "output-*-iso";
                Remove-Item "output-*-iso" -Recurse | Out-Null;
            }
            if ( Get-Item "$imageName.box" -ErrorAction Ignore ) {
                Write-Host "$(Get-Date) Found current box file, now removing";
                Get-Item "$imageName.box";
                Remove-Item "$imageName.box";
            }
            Write-Host "$(Get-Date) Starting packer";
            packer build -only virtualbox-iso,hyperv-iso "$imageName.json"
            if ( Get-Item "$imageName.box" -ErrorAction Ignore ) {
                Write-Host "$(Get-Date) Adding image to vagrant";
                vagrant box add "$imageName.box" --name $imageName
                Write-Host "$(Get-Date) Removing temporary box file";
                Remove-Item "$imageName.box";
                $existingImages = vagrant box list | ? { $_ -like "$imageName *" };
                if ( $existingImages ) {
                    $jobDone = $true;
                } else {
                    Write-Host "$(Get-Date) Vagrant box is not found, sleeping before starting the next step";
                    Sleep 300;
                }
            } else {
                Write-Host "$(Get-Date) Vagrant box file is not found, sleeping before starting the next step";
                Sleep 300;
            }
        } else {
            Write-Host "$(Get-Date) Image is already registered in vagrant";
            $jobDone = $true;
        }
    } While ( ( $retriesCounter -lt $retriesLimit ) -and !$jobDone )
}
Write-Host "$(Get-Date) Operation took:";
( Get-Date ) - $startProcessingMoment;
