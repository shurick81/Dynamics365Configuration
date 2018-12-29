#$filePath = ".\sp-devops-starter.busy.txt"
#if ( Get-Item $filePath -ErrorAction Ignore ) {
    Remove-Item "c:\sp-devops-starter.busy.txt" -Force
#    Remove-Item $filePath -Force
#}