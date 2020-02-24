Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -RequiredVersion 2.8.5.201
Get-ChildItem
Publish-Module -Path ".\src\Dynamics365Configuration" -NuGetApiKey $env:NuGetApiKey