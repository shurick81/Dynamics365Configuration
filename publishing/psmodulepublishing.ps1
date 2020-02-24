Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -RequiredVersion 2.8.5.201
Import-Module .\src\Dynamics365Configuration
Publish-Module -Name Dynamics365Configuration -NuGetApiKey $env:NuGetApiKey