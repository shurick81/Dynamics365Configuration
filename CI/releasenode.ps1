#$filePath = ".\Dynamics365Configuration.busy.txt"
#if ( Get-Item $filePath -ErrorAction Ignore ) {
    Remove-Item "c:\Dynamics365Configuration.busy.txt" -Force
#    Remove-Item $filePath -Force
#}