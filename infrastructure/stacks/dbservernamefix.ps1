$serverNameResponse = Invoke-Sqlcmd "Select @@SERVERNAME" -ServerInstance "DB01\SPIntra01"
$serverName = $serverNameResponse.Column1
Write-Host "Previous server name was $serverName"
$serverNameResponse = Invoke-Sqlcmd ( "sp_dropserver '" + $serverName + "'" ) -ServerInstance "DB01\SPIntra01"
$serverNameResponse = Invoke-Sqlcmd ( "sp_addserver 'DB01\SPIntra01', 'local'" ) -ServerInstance "DB01\SPIntra01"
$serverNameResponse = Invoke-Sqlcmd "sp_helpserver" -ServerInstance "DB01\SPIntra01"
Write-Host "Restarting instance"
CD SQLSERVER:\SQL\db01
$Wmi = (get-item .).ManagedComputer  
$DBEngineInstance = $Wmi.Services['MSSQL$SPINTRA01']
$DBEngineInstance.Stop();
Sleep 15;
$DBEngineInstance.Refresh();
$DBEngineInstance.Start();
Sleep 15;
$DBEngineInstance.Refresh();

$AgentInstance = $Wmi.Services['SQLAgent$SPINTRA01']
$AgentInstance.Start();
Sleep 15;
$AgentInstance.Refresh();

$serverNameResponse = Invoke-Sqlcmd "Select @@SERVERNAME" -ServerInstance "DB01\SPIntra01"
$serverName = $serverNameResponse.Column1
Write-Host "New server name is $serverName"
