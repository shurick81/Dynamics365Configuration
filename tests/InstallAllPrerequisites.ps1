try {
    Install-Dynamics365Prerequisite VisualCPlusPlusRuntime;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{A749D8E6-B613-3BE3-8F5F-045C84EBA29B}" }
if ( !$installedProduct )
{
    Write-Host "Matching products not found";
    Exit 1;
} else {
    Write-Host "Product A749D8E6-B613-3BE3-8F5F-045C84EBA29B found"
}

try {
    Install-Dynamics365Prerequisite;
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