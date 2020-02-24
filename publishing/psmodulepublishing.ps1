Get-PackageProvider NuGet -ForceBootstrap
Invoke-WebRequest -Uri https://aka.ms/psget-nugetexe -OutFile 'NuGet.exe'
Publish-Module -Path ".\src\Dynamics365Configuration" -NuGetApiKey $env:NuGetApiKey