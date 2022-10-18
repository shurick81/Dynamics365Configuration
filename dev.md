```PowerShell
git clone https://github.com/shurick81/Dynamics365Configuration C:\projects\Dynamics365Configuration
choco install -y packer
choco install -y virtualbox
choco install -y vagrant
```

```
Import-Module ./src/Dynamics365Configuration/Dynamics365Configuration.psd1;
.\src\misc\checksumextractor.ps1
```