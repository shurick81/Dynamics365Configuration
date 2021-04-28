@(
    'SharedManagementObjects2016',
    'MSODBCSQL',
    'SQLNCli2008R2',
    'SQLSysClrTypes2012',
    'SharedManagementObjects2012',
    'ReportViewer2012'
) | % {
    try {
        Save-Dynamics365Resource $_ C:\Install\Dynamics\$_;
    } catch {
        Write-Host $_.Exception.Message -ForegroundColor Red;
        Exit 1;
    }
}
Write-Host "$( Get-Date ) Testing";
try {
    Install-Dynamics365Prerequisite -DynamicsPrerequisiteFilePath C:\Install\Dynamics;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
@(
    'SharedManagementObjects2016',
    'MSODBCSQL',
    'SQLNCli2008R2',
    'SQLSysClrTypes2012',
    'SharedManagementObjects2012',
    'ReportViewer2012'
) | % {
    $expectedProduct = $Dynamics365Resources.$_.IdentifyingNumber;
    $installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{$expectedProduct}" }
    if ( !$installedProduct )
    {
        Write-Host "Matching products not found";
        Exit 1;
    } else {
        Write-Host "Product $expectedProduct found"
    }
}
Exit 0;