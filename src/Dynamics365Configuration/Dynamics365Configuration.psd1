#
# Module manifest for module 'manifest'
#
# Generated by: Aleksandr Sapozhkov
#
# Generated on: 2018-12-15
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'RootModule.psm1'

# Version number of this module.
ModuleVersion = '2.30.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'bced3ed6-2f8e-4198-b75f-9b062f51fd74'

# Author of this module
Author = 'Aleksandr Sapozhkov'

# Company or vendor of this module
# CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2023 Aleksandr Sapozhkov. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A module to ease infrastructure as code tasks for Dynamics 365.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Expand-Dynamics365Resource',
    'Expand-Dynamics365Resource',
    'Save-Dynamics365Resource',
    'Get-Dynamics365ServerVersion',
    'Get-Dynamics365ReportingExtensionsVersion',
    'Get-Dynamics365ServerRole',
    'Get-Dynamics365ServerLanguage',
    'Install-Dynamics365Prerequisite',
    'Install-Dynamics365Server',
    'Install-Dynamics365ReportingExtensions',
    'Install-Dynamics365Language',
    'Install-Dynamics365Update',
    'Install-Dynamics365ReportingExtensionsUpdate',
    'Install-Dynamics365LanguageUpdate'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
# CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = 'Dynamics365Resources'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @( 'CRM', 'CRM2016', 'Dynamics', 'Dynamics365Server', 'Deployment' )

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/shurick81/Dynamics365Configuration'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/shurick81/Dynamics365Configuration'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
