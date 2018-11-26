$period = 1; #How regularly to measure
$successThreshold = 9; #What CPU usage percentage to consider calm
$successThresholdTimes = 300; #How many times are counted
$failureThresholdTimes = 20; #How many times are counted for not calm CPU for starting count again

$startMoment = Get-Date;
$calmTimes = 0;
$busyTimes = 0;
do {
    Sleep $period;
    $cpu =  Get-WmiObject win32_processor;
    $loadPercentage = $cpu.LoadPercentage;
    if ( $loadPercentage -le $successThreshold ) { $calmTimes++; } else { $busyTimes++ }
    Write-Host "Current percentage: $loadPercentage, calm times: $calmTimes, busy times: $busyTimes"
    if ( $busyTimes -ge $failureThresholdTimes ) {
        $calmTimes = 0;
        $busyTimes = 0;
    }
} until ( $calmTimes -ge $successThresholdTimes )
Write-Host "Waited:"
( Get-Date ) - $startMoment