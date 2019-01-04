# Before running this test, make sure that current directory contains prerequisite files
try {
    Install-Dynamics365Prerequisites;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
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