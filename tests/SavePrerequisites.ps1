Save-Dynamics365Resource SQLNCli2012SP4;
Save-Dynamics365Resource SQLSysClrTypes2016;
Save-Dynamics365Resource SharedManagementObjects2016;
Save-Dynamics365Resource MSODBCSQL;
Save-Dynamics365Resource SQLNCli2018R2;
Save-Dynamics365Resource SQLSysClrTypes2012;
Save-Dynamics365Resource SharedManagementObjects2012;
Save-Dynamics365Resource ReportViewer2012;

$expectedFiles = @(
    ".\SQLNCli2012SP4\sqlncli.msi",
    ".\SQLSysClrTypes2016\SQLSysClrTypes.msi",
    ".\SharedManagementObjects2016\SharedManagementObjects.msi",
    ".\MSODBCSQL\msodbcsql.msi",
    ".\SQLNCli2018R2\sqlncli.msi",
    ".\SQLSysClrTypes2012\SQLSysClrTypes.msi",
    ".\SharedManagementObjects2012\SharedManagementObjects.msi",
    ".\ReportViewer2012\ReportViewer.msi"
)
$expectedFiles | % {
    if ( !( Get-Item $_ -ErrorAction Ignore ) ) {
        Write-Host "Files $_ not found"
        Write-Host "Test not OK"
        Remove-Item $_ -Force;    
        Exit 1;
    } else {
        Write-Host "Files $_ found"
    }
    Remove-Item $_ -Force;    
}
Write-Host "Test OK"
Exit 0;