Import-Module $PSScriptRoot\Dynamics365Resources.psm1
$Dynamics365Resources = $Dynamics365Resources;
Import-Module $PSScriptRoot\Expand-Dynamics365Resource.psm1
Import-Module $PSScriptRoot\Save-Dynamics365Resource.psm1 -DisableNameChecking
Import-Module $PSScriptRoot\Get-Dynamics365ServerVersion.psm1
Import-Module $PSScriptRoot\Get-Dynamics365ServerRoles.psm1
Import-Module $PSScriptRoot\Get-Dynamics365ServerLanguage.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Prerequisite.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Server.psm1
Import-Module $PSScriptRoot\Install-Dynamics365ReportingExtensions.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Language.psm1
Import-Module $PSScriptRoot\Install-Dynamics365Update.psm1
Import-Module $PSScriptRoot\Install-Dynamics365ReportingExtensionsUpdate.psm1
Import-Module $PSScriptRoot\Install-Dynamics365LanguageUpdate.psm1

Export-ModuleMember -Variable Dynamics365Resources
Export-ModuleMember -Function Expand-Dynamics365Resource
Export-ModuleMember -Function Save-Dynamics365Resource
Export-ModuleMember -Function Get-Dynamics365ServerVersion
Export-ModuleMember -Function Get-Dynamics365ServerRoles
Export-ModuleMember -Function Get-Dynamics365ServerLanguage
Export-ModuleMember -Function Install-Dynamics365Prerequisite
Export-ModuleMember -Function Install-Dynamics365Server
Export-ModuleMember -Function Install-Dynamics365ReportingExtensions
Export-ModuleMember -Function Install-Dynamics365Language
Export-ModuleMember -Function Install-Dynamics365Update
Export-ModuleMember -Function Install-Dynamics365ReportingExtensionsUpdate
Export-ModuleMember -Function Install-Dynamics365LanguageUpdate
