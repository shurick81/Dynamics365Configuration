Install-Module PowerShellGet -MinimumVersion 1.6.8 -Force -AllowClobber
Copy-Item ".\src\Dynamics365Configuration" "C:\Users\$env:username\Documents\WindowsPowerShell\Modules" -Recurse -Force
Publish-Module -Name Dynamics365Configuration -NuGetApiKey $nuGetApiKey