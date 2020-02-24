Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -RequiredVersion 2.8.5.201
$absolutePath = Resolve-Path ".\src\Dynamics365Configuration";
Publish-Module -Path $absolutePath -NuGetApiKey $env:NuGetApiKey