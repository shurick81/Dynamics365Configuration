Save-Dynamics365Resource VisualCPlusPlusRuntime;
Write-Host "$( Get-Date ) Testing";
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

Save-Dynamics365Resource VisualCPlusPlus2010Runtime C:\Install\Dynamics\VisualCPlusPlus2010Runtime;
Write-Host "$( Get-Date ) Testing";
try {
    Install-Dynamics365Prerequisite VisualCPlusPlus2010Runtime C:\Install\Dynamics;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{1D8E6291-B0D5-35EC-8441-6616F567A0F7}" }
if ( !$installedProduct )
{
    Write-Host "Matching products not found";
    Exit 1;
} else {
    Write-Host "Product 1D8E6291-B0D5-35EC-8441-6616F567A0F7 found"
}

Save-Dynamics365Resource SQLNCli2012SP4 C:\Install\Dynamics\SQLNCli2012SP4;
Write-Host "$( Get-Date ) Testing";
try {
    Install-Dynamics365Prerequisite SQLNCli2012SP4 C:\Install\Dynamics\SQLNCli2012SP4;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{B9274744-8BAE-4874-8E59-2610919CD419}" }
if ( !$installedProduct )
{
    Write-Host "Matching products not found";
    Exit 1;
} else {
    Write-Host "Product B9274744-8BAE-4874-8E59-2610919CD419 found"
}

Save-Dynamics365Resource SQLSysClrTypes2016 C:\Install\Dynamics\SQLSysClrTypes2016;
Write-Host "$( Get-Date ) Testing";
try {
    Install-Dynamics365Prerequisite SQLSysClrTypes2016 C:\Install\Dynamics\SQLSysClrTypes2016\SQLSysClrTypes.msi;
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red;
    Exit 1;
}
$installedProduct = Get-WmiObject Win32_Product | ? { $_.IdentifyingNumber -eq "{96EB5054-C775-4BEF-B7B9-AA96A295EDCD}" }
if ( !$installedProduct )
{
    Write-Host "Matching products not found";
    Exit 1;
} else {
    Write-Host "Product 96EB5054-C775-4BEF-B7B9-AA96A295EDCD found"
}

@(
    'SharedManagementObjects2016',
    'MSODBCSQL',
    'SQLNCli2008R2',
    'SQLSysClrTypes2012',
    'SharedManagementObjects2012',
    'ReportViewer2012'
) | % {
    Save-Dynamics365Resource $_ C:\Install\Dynamics\$_;
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