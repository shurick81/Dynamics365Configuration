function Get-Dynamics365ServerLanguage {
    $msCRMRegistryValues = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\MSCRM -ErrorAction Ignore;
    if ( $msCRMRegistryValues ) {
        $language = $msCRMRegistryValues.LanguageID;
        if ( $language ) {
            return [int]$language;
        } else {
            $errorMessage = "LanguageID registry value is not found";
            Write-Output $errorMessage;
            Throw $errorMessage;
        }
    } else {
        $errorMessage = "HKLM:\SOFTWARE\Microsoft\MSCRM registry key is not found";
        Write-Output $errorMessage;
        Throw $errorMessage;
    }
}
