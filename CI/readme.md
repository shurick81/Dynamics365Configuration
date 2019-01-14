## Prepare the agent machine

1. Install requred software

Run in PowerShell:
```PowerShell
$resourceUrl = "https://vstsagentpackage.azureedge.net/agent/2.144.0/vsts-agent-win-x64-2.144.0.zip";
$tempFileName = [guid]::NewGuid().Guid + ".zip";
$tempFilePath = "$env:TEMP\$tempFileName";
Write-Host "Downloading $resourceUrl to $tempFilePath";
$currentProgressPreference = $ProgressPreference;
$ProgressPreference = 'SilentlyContinue';
Invoke-WebRequest -Uri $resourceUrl -OutFile $tempFilePath;
$ProgressPreference = $currentProgressPreference;

$dirPath = "c:\AzurePipelineAgent";
New-Item $dirPath -ItemType Directory -Force | Out-Null;
Add-Type -AssemblyName System.IO.Compression.FileSystem;
Write-Host "Unpacking $tempFilePath to $dirPath";
[System.IO.Compression.ZipFile]::ExtractToDirectory( $tempFilePath, $dirPath );

Set-ExecutionPolicy Bypass -Force;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y packer
choco install -y virtualbox --version 5.2.22
choco install -y vagrant --version 2.2.0
```
Reboot the machine if vagrant had not been installed before.

Run in PowerShell:
```PowerShell
vagrant plugin install vagrant-reload
```

## Run the agent

1. Save Azure Devops Personal Access Token in AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN environment variable.
2. Run in PowerShell
```PowerShell
cd c:\AzurePipelineAgent
Write-Host "Running config.cmd";
.\config.cmd --unattended --url https://sapozhkov.visualstudio.com --auth pat --token $env:AZURE_DEVOPS_PERSONAL_ACCESS_TOKEN --acceptTeeEula
.\run.cmd
```
3. Configure integration with Azure Pipelines in GitHub.
4. Add a new pipeline in Azure and select /azure-pipelines.yml as a source file.
