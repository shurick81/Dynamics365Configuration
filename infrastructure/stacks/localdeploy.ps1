$complete = $false;
$retries = 5
While ( !$complete -and $retries -gt 0 )
{
    Write-Host "$(Get-Date) Trying vagrant up, retries left: $retries"
    vagrant up
    if ( $LASTEXITCODE -eq 0 )
    {
        $complete = $true;
        Write-Host "$(Get-Date) Succeeded with vagrant up"
        Exit 0;
    } else {
        Write-Host "$(Get-Date) Failed with vagrant up, running vagrant destroy"
        vagrant destroy --force
    }
    $retries--;
}
Exit 1;