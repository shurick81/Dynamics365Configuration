New-Item -Path C:\Temp -ItemType Directory -Force | Out-Null;
Write-Host "$( Get-Date ) Downloading http://download.windowsupdate.com/d/msdownload/update/software/ftpk/2018/07/windows8.1-kb4054566-x64_e780e6efac612bd0fcaf9cccfe15d6d05c9cc419.msu"
(New-Object System.Net.WebClient).DownloadFile('http://download.windowsupdate.com/d/msdownload/update/software/ftpk/2018/07/windows8.1-kb4054566-x64_e780e6efac612bd0fcaf9cccfe15d6d05c9cc419.msu', 'C:\Temp\windows8.1-kb4054566-x64_e780e6efac612bd0fcaf9cccfe15d6d05c9cc419.msu' );
Write-Host "$( Get-Date ) Starting C:\Temp\windows8.1-kb4054566-x64_e780e6efac612bd0fcaf9cccfe15d6d05c9cc419.msu"
Start-Process wusa.exe -ArgumentList '"C:\Temp\windows8.1-kb4054566-x64_e780e6efac612bd0fcaf9cccfe15d6d05c9cc419.msu" /quiet';
