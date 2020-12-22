function Get-Dynamics365ReportingExtensionsVersion {
    $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
    if ( $msCRMRegistryValues ) {
        $version = $msCRMRegistryValues.CRM_SrsDataConnector_Serviceability_Version;
        if ( $version ) {
            return [version]$version;
        } else {
            $errorMessage = "CRM_SrsDataConnector_Serviceability_Version registry value is not found";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        $errorMessage = "HKLM:\SOFTWARE\Microsoft\MSCRM registry key is not found";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
}
