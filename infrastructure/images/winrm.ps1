# move all (non-domain) network interfaces into the private profile to make winrm happy (it needs at
# least one private interface; for vagrant its enough to configure the first network interface).
Get-NetConnectionProfile `
    | Where-Object {$_.NetworkCategory -ne 'DomainAuthenticated'} `
    | Set-NetConnectionProfile -NetworkCategory Private

# configure WinRM.
Write-Output 'Configuring WinRM...'
winrm quickconfig -quiet
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/Config '@{MaxEnvelopeSizekb = "1536"}'
$result = sc.exe config WinRM start= auto
if ($result -ne '[SC] ChangeServiceConfig SUCCESS') {
    throw "sc.exe config failed with $result"
}

# make sure winrm can be accessed from any network profile.
$winRmFirewallRuleNames = @(
    'WINRM-HTTP-In-TCP',        # Windows Remote Management (HTTP-In)
    'WINRM-HTTP-In-TCP-PUBLIC'  # Windows Remote Management (HTTP-In)   # Windows Server
    'WINRM-HTTP-In-TCP-NoScope' # Windows Remote Management (HTTP-In)   # Windows 10
)
Get-NetFirewallRule -Direction Inbound -Enabled False `
    | Where-Object {$winRmFirewallRuleNames -contains $_.Name} `
    | Set-NetFirewallRule -Enable True

Write-Host "PACKER_BUILDER_TYPE: $env:PACKER_BUILDER_TYPE"
if ( !( $env:PACKER_BUILDER_TYPE -eq "azure-arm" ) ) {
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name LocalAccountTokenFilterPolicy -PropertyType DWord -Value 1
}
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force