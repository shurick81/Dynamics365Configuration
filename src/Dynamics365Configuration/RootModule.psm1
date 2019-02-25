Import-Module $PSScriptRoot\Dynamics365Resources.psm1
$Dynamics365Resources = $Dynamics365Resources;
Import-Module $PSScriptRoot\Expand-Dynamics365Resource.psm1
Import-Module $PSScriptRoot\Save-Dynamics365Resource.psm1 -DisableNameChecking
Import-Module $PSScriptRoot\Install-Dynamics365Prerequisite.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Server.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Language.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Update.psm1
Import-Module $PSScriptRoot\Install-Dynamics365ReportingExtensions.psm1

Export-ModuleMember -Variable Dynamics365Resources
Export-ModuleMember -Function Expand-Dynamics365Resource
Export-ModuleMember -Function Save-Dynamics365Resource
Export-ModuleMember -Function Install-Dynamics365Prerequisite
Export-ModuleMember -Function Install-Dynamics365Server
Export-ModuleMember -Function Install-Dynamics365Language
Export-ModuleMember -Function Install-Dynamics365Update
Export-ModuleMember -Function Install-Dynamics365ReportingExtensions