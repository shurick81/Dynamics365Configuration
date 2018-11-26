[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$stackName = "dev-2016"
)

$stackPath = Join-Path (Resolve-Path ./).Path $stackName;
Start-Process Vagrant -WorkingDirectory $stackPath -ArgumentList "up AD01 --provider azure" -Wait -NoNewWindow;
$idContent = Get-Content ".\$stackName\.vagrant\machines\AD01\azure\id";
$idValues = $idContent.Split(":");
$resourceGroupName = $idValues[0];
$machineName = $idValues[1];
$appId = $env:ARM_CLIENT_ID;
$appPass = $env:ARM_CLIENT_SECRET;
$securedPassword = ConvertTo-SecureString $appPass -AsPlainText -Force;
$azureCredential = New-Object System.Management.Automation.PSCredential( $appId, $securedPassword );
Connect-AzureRmAccount -Credential $azureCredential -ServicePrincipal -TenantId $env:ARM_TENANT_ID | Out-Null;
$vm = Get-AzureRmVM -ResourceGroupName $resourceGroupName -VMName $machineName
$networkInterfaceRef = $vm.NetworkProfile[0].NetworkInterfaces[0].id;
$networkInterface = Get-AzureRmNetworkInterface | ? { $_.Id -eq $networkInterfaceRef }
$networkInterface.IpConfigurations[0].PrivateIpAllocationMethod = "Static"
Set-AzureRmNetworkInterface -NetworkInterface $networkInterface | Out-Null;
$networkInterface.IpConfigurations[0]
$updateDnsServersScript = {
    param( $resourceGroupName, $vnName, $dnsServer )
    $timeStamp = ( Get-Date -Format u ).Replace(" ","-").Replace(":","-");
    Start-Transcript -Path "$env:TEMP\updateDnsServersScriptLog_$timeStamp.txt" -Append;
    Write-Host "Hello"
    $addressList = @( $dnsServer, "8.8.8.8" )
    $appId = $env:ARM_CLIENT_ID;
    $appPass = $env:ARM_CLIENT_SECRET;
    $securedPassword = ConvertTo-SecureString $appPass -AsPlainText -Force;
    $azureCredential = New-Object System.Management.Automation.PSCredential( $appId, $securedPassword );
    Write-Host "Connnecting to AzureRmAccount ..."
    Connect-AzureRmAccount -Credential $azureCredential -ServicePrincipal -TenantId $env:ARM_TENANT_ID;
    Write-Host "Connnected"
    1..1000 | % {
        Write-Host "Obtaining VN"
        $vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -name $vnName;
        if ( !$vnet.DhcpOptions.DnsServers ) {
            $vnet.DhcpOptions.DnsServers = $addressList;
            Write-Host "Updating VN"
            Set-AzureRmVirtualNetwork -VirtualNetwork $vnet | Out-Null;
        }
        Sleep 10;
    }
    Stop-Transcript
}
$job = Start-Job -ScriptBlock $updateDnsServersScript -ArgumentList $resourceGroupName, 'vagrantVNET', $networkInterface.IpConfigurations[0].PrivateIpAddress
$job
Start-Process Vagrant -WorkingDirectory $stackPath -ArgumentList "up --provider azure --no-parallel" -Wait -NoNewWindow;
Stop-Job $job
Remove-Job $job