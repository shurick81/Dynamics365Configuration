New-Item -Path C:\Temp -ItemType Directory -Force | Out-Null
Write-Host "$( Get-Date ) Downloading https://go.microsoft.com/fwlink/?linkid=839516"
(New-Object System.Net.WebClient).DownloadFile('https://go.microsoft.com/fwlink/?linkid=839516', 'C:\Temp\Win8.1AndW2K12R2-KB3191564-x64.msu')
Write-Host "$( Get-Date ) Extracting"
New-Item c:\temp\win8.1AndW2K12R2-KB3191564-x64 -ItemType Directory
expand -F:* C:\Temp\Win8.1AndW2K12R2-KB3191564-x64.msu C:\Temp\Win8.1AndW2K12R2-KB3191564-x64
Get-ChildItem C:\temp
Write-Host "$( Get-Date ) Starting installing"
$job = Start-Job -ScriptBlock { dism.exe /Online /Add-Package /PackagePath:C:\temp\Win8.1AndW2K12R2-KB3191564-x64\WindowsBlue-KB3191564-x64.cab /Quiet }
Write-Host "$( Get-Date ) Done"
Sleep 30;
Exit 0;