Remove-Module PowerShellGet
Install-Module PowerShellGet -MinimumVersion 1.6.8 -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
New-Item C:\Users\$env:username\Documents\WindowsPowerShell\Modules -ItemType Directory -ErrorAction SilentlyContinue;
Remove-Item "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\Dynamics365Configuration" -Recurse -Force -ErrorAction Ignore
Copy-Item ".\src\Dynamics365Configuration" "C:\Users\$env:username\Documents\WindowsPowerShell\Modules" -Recurse -Force
Import-Module "C:\Users\$env:username\Documents\WindowsPowerShell\Modules\Dynamics365Configuration";
Publish-Module -Name Dynamics365Configuration -NuGetApiKey $env:NuGetApiKey