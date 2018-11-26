Get-WSManCredSSP
$securedPassword = ConvertTo-SecureString "c0mp1Expa~~" -AsPlainText -Force
$SPInstallAccountCredential = New-Object System.Management.Automation.PSCredential( "contoso\_spadm16", $securedPassword );
$result = Invoke-Command "OPS01.contoso.local" -Credential $SPInstallAccountCredential -Authentication CredSSP {
    Get-ChildItem c:\
}
if ( !$result )
{
    Write-Host "Test failed"
    Exit 1;
}
Write-Host "Test succeeded"
Exit 1;
