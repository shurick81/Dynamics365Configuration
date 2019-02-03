Import-Module SQLPS;
$serverNameResponse = Invoke-Sqlcmd "Select @@SERVERNAME" -ServerInstance "$env:COMPUTERNAME\SQLInstance01";
$serverName = $serverNameResponse.Column1;
Write-Host "Previous server name was $serverName";
$serverNameResponse = Invoke-Sqlcmd ( "sp_dropserver '" + $serverName + "'" ) -ServerInstance "$env:COMPUTERNAME\SQLInstance01";
$serverNameResponse = Invoke-Sqlcmd ( "sp_addserver '$env:COMPUTERNAME\SQLInstance01', 'local'" ) -ServerInstance "$env:COMPUTERNAME\SQLInstance01";
$serverNameResponse = Invoke-Sqlcmd "sp_helpserver" -ServerInstance "$env:COMPUTERNAME\SQLInstance01";
Write-Host "Restarting instance";
CD SQLSERVER:\SQL\$env:COMPUTERNAME;
$Wmi = ( get-item . ).ManagedComputer;
$DBEngineInstance = $Wmi.Services[ 'MSSQL$SQLInstance01' ];
$DBEngineInstance.Stop();
Sleep 15;
$DBEngineInstance.Refresh();
$DBEngineInstance.Start();
Sleep 15;
$DBEngineInstance.Refresh();

$AgentInstance = $Wmi.Services[ 'SQLAgent$SQLInstance01' ];
$AgentInstance.Start();
Sleep 15;
$AgentInstance.Refresh();

$serverNameResponse = Invoke-Sqlcmd "Select @@SERVERNAME" -ServerInstance "$env:COMPUTERNAME\SQLInstance01";
$serverName = $serverNameResponse.Column1;
Write-Host "New server name is $serverName";
