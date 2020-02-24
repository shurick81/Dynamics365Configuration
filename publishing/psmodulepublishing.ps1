Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Publish-Module -Path ".\src\Dynamics365Configuration" -NuGetApiKey $env:NuGetApiKey