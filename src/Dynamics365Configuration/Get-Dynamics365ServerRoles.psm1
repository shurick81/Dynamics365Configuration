function Get-Dynamics365ServerRoles {
    $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
    if ( $msCRMRegistryValues ) {
        $roleNames = $msCRMRegistryValues.RoleNames;
        if ( $roleNames ) {
            return $roleNames -split ",";
        } else {
            $errorMessage = "RoleNames registry value is not found";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        $errorMessage = "HKLM:\SOFTWARE\Microsoft\MSCRM registry key is not found";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
}
