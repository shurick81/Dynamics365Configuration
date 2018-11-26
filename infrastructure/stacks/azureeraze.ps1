[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=1)]
    [string]$stackName = "dev-2016"
)

$stackPath = Join-Path (Resolve-Path ./).Path $stackName;
Start-Process Vagrant -WorkingDirectory $stackPath -ArgumentList "destroy --force" -Wait -NoNewWindow;