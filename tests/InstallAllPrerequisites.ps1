# Before running this test, make sure that current directory contains prerequisite files
Install-Dynamics365Prerequisites -Debug;
if ( $LASTEXITCODE -eq 0 )
{
    Write-Host "Test OK";
    Exit 1;
} else {
    Write-Host "Test Not OK"
    Exit 0;
}