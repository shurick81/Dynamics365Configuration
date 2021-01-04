# backup the key
$KeyFolder = "C:\Temp";
$KeyPassword = "sa@123@123";
$TimeStamp = Get-Date -Format "-yyyyMMdd-HHmmss";
$instanceName = "SSRS";
$NameSpaceRS = "RS_$instanceName";
$serviceName = "ReportServer`$$instanceName";
$KeyFileName = Join-Path -Path $KeyFolder -ChildPath ( $InstanceName + $Timestamp + ".snk" );
New-Item $KeyFolder -ItemType Directory -Force | Out-Null;
$SQLVersion = ( Get-WmiObject -Namespace "Root\Microsoft\SqlServer\ReportServer\$($NameSpaceRS)" -Class "__Namespace" ).Name;
$SSRSClass = Get-WmiObject -Namespace "Root\Microsoft\SqlServer\ReportServer\$($NameSpaceRS)\$($SQLVersion)\Admin" -Query "SELECT * FROM MSReportServer_ConfigurationSetting WHERE InstanceName='$($InstanceName)'";
$Key = $SSRSClass.BackupEncryptionKey($KeyPassword)
If ( $Key.HRESULT -ne 0 ) {
    $Key.ExtendedErrors -join "`r`n" | Write-Error;
} Else {
    $Stream = [System.IO.File]::Create( $KeyFileName, $Key.KeyFile.Length );
    $Stream.Write( $Key.KeyFile, 0, $Key.KeyFile.Length );
    $Stream.Close();
}

# change the service account
$changeServiceArguments = @{
    StartName       = "contoso\_ssrs"
    StartPassword   = "c0mp1Expa~~"
}
$serviceCimInstance = Get-CimInstance -ClassName 'Win32_Service' -Filter "Name='$serviceName'";
Invoke-CimMethod -InputObject $ServiceCimInstance -MethodName 'Change' -Arguments $changeServiceArguments;
Stop-Service $serviceName -ErrorAction Stop
Start-Service $serviceName -ErrorAction Stop

# restore the key
if (![System.IO.File]::Exists( $KeyFileName ) ) 
{
    Write-Error "No key was found at the specified location: $KeyFileName";
    Exit 1
}
$keyBytes = [System.IO.File]::ReadAllBytes( $KeyFileName );
$SSRSClass.RestoreEncryptionKey( $keyBytes, $keyBytes.Length, $KeyPassword );
