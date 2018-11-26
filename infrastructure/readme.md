# SP 2013 Requirements
* Hardware
  * 12GB free RAM
  * 100GB free disk space
* Software
  * Vagrant
  * Vagrant reload
  * Packer
  * Oracle VirtualBox or Hyper-V or VMWare
  * C:/sp-onprem-files/SPServer2013SP1 directory with SP installation media with classic structure:
    * 2013
      * SharePoint
      * LanguagePacks

Use AutoSPSourceBuilder to generate this one or extract from SP iso to C:/sp-onprem-files/SPServer2013SP1/2013/SharePoint

* ~ 3 hours to run tests

Run in PowerShell:
```PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y vagrant
```
If Vagrant package requires reboot, you need to do it before proceeding further
Then reboot for finishing insalling Vagrant and continue with `vagrant plugin install vagrant-reload`

If you want to speed up the installation for the first time, save Windows installation media from https://download.microsoft.com/download/6/2/A/62A76ABB-9990-4EFC-A4FE-C7D698DAEB96/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO to C:/sp-onprem-files/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso

Copy C:/sp-onprem-files/SPServer2013SP1 directory to /infrastructure directory of this repository.
Then `cd` to the `/infrastructure` directory and run:
```PowerShell
$directoryName = [guid]::NewGuid().Guid;
New-Item -Path "$env:Temp\$directoryName" -ItemType Directory -Force | Out-Null
Invoke-RestMethod -Uri https://download.visualstudio.microsoft.com/download/pr/12221250/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe -OutFile "$env:Temp\$directoryName\vs_Enterprise.exe"
# https://download.visualstudio.microsoft.com/download/pr/11346816/52257ee3e96d6e07313e41ad155b155a/vs_Enterprise.exe was the old URL
Start-Process -FilePath "$env:Temp\$directoryName\vs_Enterprise.exe" -ArgumentList '--layout .\VS2017 --add Microsoft.VisualStudio.Workload.Office --includeRecommended --lang en-US --quiet' -Wait;
.\media.ps1 .\media2013.json
Remove-Item .\VS2017 -Recurse -Force
if ( !( Get-Item ./images/packer_cache/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso -ErrorAction Ignore ) ) {
  if ( Get-Item C:/sp-onprem-files/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso -ErrorAction Ignore )
  {
    Copy-Item C:/sp-onprem-files/d408977ecf91d58e3ae7c4d0f515d950c4b22b8eadebd436d57f915a0f791224.iso ./images/packer_cache
  }
}
```

### Removing IE Enhanced Security
```PowerShell
$adminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $adminKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
```

### Installing VirtualBox on Windows

```
choco install -y virtualbox --version 5.2.14
```

For uninstalling VirtualBox, run `choco uninstall -y virtualbox`

### (alernatively) Installing Hyper-V on Windows Server or Windows Pro

```PowerShell
New-NetFirewallRule -DisplayName 'Packer HTTP ports' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8000-9000 | Out-Null
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
```

You will need to reboot the machine for changes to apply
Using Hyper-V Manager, configure network switch with external access.

For uninstalling Hyper-V, run:

```
Get-NetFirewallRule | ? { $_.DisplayName -eq 'Packer HTTP ports' } | Disable-NetFirewallRule
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```

### Azure RM

1. `vagrant plugin install vagrant-azure`
2. Make sure you have storage account for saving images
3. Create application and assign proper roles for managing Azure resources
4. Set values for following variables:
* ARM_CLIENT_ID
* ARM_CLIENT_SECRET
* ARM_SUBSCRIPTION_ID
* ARM_TENANT_ID

Use this instruction as a baseline: https://www.packer.io/docs/builders/azure-setup.html

in admin PowerShell run:
``` PowerShell
Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y git
choco install -y vagrant
Install-Module -Name AzureRM.Compute -RequiredVersion 5.2.0 -Force
Install-Module -Name AzureRm.Network -RequiredVersion 6.4.0 -Force # - Needed?
```
If Vagrant package needs a reboot, do it before proceeding further.

```PowerShell
vagrant plugin install vagrant-azure;
Rename-Item -Path C:\Users\<windowslogin>\.vagrant.d\gems\2.4.4\gems\vagrant-azure-2.0.0 -NewName "vagrant-azure-2.0.0 - Copy";
git clone https://github.com/shurick81/vagrant-azure C:\Users\<windowslogin>\.vagrant.d\gems\2.4.4\gems\vagrant-azure-2.0.0;
```

# Cloud dev machine
If you want to use dev environment in the cloud, it makes sense to use cloud dev machine for running this solution from the cloud and avoid interruptions when your physical development machine is offline.

Before these steps, you need to prepare all Azure RM prerequisites.

## PowerShell

`cd` to `images` directory and run `packer build env-win2016-dev.json`
`vagrant box add azure https://github.com/azure/vagrant-azure/raw/v2.0/dummy.box --provider azure`
`cd` to `stacks/dev-env` directory and run `vagrant up`
Now you can connect to this Azure VM via `vagrant` `Vagrant365` credentials. This machine has all VM-management tools and dev tools pre-installed, so clone your project on it and run further commands from it.

```
git clone https://github.com/shurick81/sp-devops-starter c:\projects\sp-devops-starter
```
If you work for example from a laptop, then further commands will not be interrupted when you shut it down or disconnect from the network.

# Creating a development environment

## PowerShell

### SharePoint 2013

`cd` to `images` directory and run `.\preparevmimages.ps1 sp-win2012r2-ad,sp-win2012r2-db-web-code`
`cd` to `stacks/dev-ad-sql2014sp2013code-spfarm` directory and run `vagrant up`

### SharePoint 2016

`cd` to `images` directory and run `.\preparevmimages.ps1 sp-win2016-ad,sp-win2016-db-web-code`
`cd` to `stacks/dev-ad-sql2016sp2016code-spfarm` directory and run `vagrant up`

### Hyper-V

When running `vagrant up` you will be asked to choose the switch manually.
if you encounter `The box is not able to report an address for WinRM to connect to yet.` exit, run `vagrant up` again.

### Resetting SP machine

```
vagrant destroy DBWEB01 --force
vagrant up
```

# Accessing the machine
Open rdp://localhost:13391 with
account: `contoso\_spadm16`
pass: `c0mp1Expa~~`

# Cleaning up
`cd` to `stack` directory and run `vagrant destroy`
`cd` to `images` directory and run `removevmimages.ps1 sp-win2012r2-ad,sp-win2012r2-db-web-code`

Consider also removing downloaded ISO files:

`rm images/packer_cache/*`