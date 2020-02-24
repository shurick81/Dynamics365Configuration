Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -RequiredVersion 2.8.5.201
Get-ChildItem $env:USERPROFILE
Get-ChildItem $env:USERPROFILE\Documents
Get-ChildItem $env:USERPROFILE\Documents\WindowsPowerShell
New-Item $env:USERPROFILE\Documents\WindowsPowerShell\Modules -ItemType Directory -ErrorAction SilentlyContinue;
Remove-Item $env:USERPROFILE\Documents\Documents\WindowsPowerShell\Modules\Dynamics365Configuration -Recurse -Force -ErrorAction Ignore
Copy-Item .\src\Dynamics365Configuration $env:USERPROFILE\Documents\WindowsPowerShell\Modules -Recurse -Force
Import-Module $env:USERPROFILE\Documents\WindowsPowerShell\Modules\Dynamics365Configuration;
Get-Module Dynamics365Configuration -ListAvailable
#Publish-Module -Name Dynamics365Configuration -NuGetApiKey $env:NuGetApiKey