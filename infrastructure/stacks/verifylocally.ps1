$retries = 5
While ( $retries -gt 0 )
{
    Write-Host "$(Get-Date) Trying vagrant up, retries left: $retries"
    vagrant up
    if ( $LASTEXITCODE -ne 0 )
    {
        Write-Host "$(Get-Date) Failed with vagrant up"
        Exit 0;
    } else {
        Write-Host "$(Get-Date) Succeeded with vagrant up, running vagrant destroy"
        vagrant destroy --force
    }
    $retries--;
}
Exit 1;