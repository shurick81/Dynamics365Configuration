$Dynamics365Resources = Get-Content -Raw -Path "$PSScriptRoot\FileResources.json" | ConvertFrom-Json;
Export-ModuleMember -Variable Dynamics365Resources
