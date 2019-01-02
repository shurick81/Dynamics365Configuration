# Before running this test, make sure that current directory contains prerequisite files
Install-Dynamics365Prerequisites;
@(
    'VisualCPlusPlusRuntime',
    'VisualCPlusPlus2010Runtime',
    'SQLNCli2012SP4',
    'SQLSysClrTypes2016',
    'SharedManagementObjects2016',
    'MSODBCSQL',
    'SQLNCli2018R2',
    'SQLSysClrTypes2012',
    'SharedManagementObjects2012',
    'ReportViewer2012'
) | % {
    $expectedProduct = $Dynamics365Resources.$_.IdentifyingNumber;
    $installedProduct = gwmi Win32_Product | ? { $_.IdentifyingNumber -eq "{$expectedProduct}" }
    if ( !$installedProduct )
    {
        Write-Host "Matcing products not found";
        Exit 1;
    } else {
        Write-Host "Product $expectedProduct found"
    }
}
Exit 0;