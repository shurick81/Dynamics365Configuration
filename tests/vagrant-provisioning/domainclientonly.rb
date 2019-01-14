Vagrant.configure(2) do |config|
    config.vm.provision :shell, path: "../../../../infrastructure/images/PackageManagementProviderResource.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/images/basepsmodules.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/images/domainclientpsmodules.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/images/xcredserver.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/images/nodefender.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/domainclientnetwork.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/domainclient.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/xcredclient.ps1"
    config.vm.provision "reload"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/crmdomainclientgroups.ps1", env: { "SPDEVOPSSTARTER_TRIALS" => 100 }
    config.vm.provision :file, source: "../../../../src", destination: "c:/tmp/Dynamics365Configuration/src"
    config.vm.provision :shell, inline: "powershell -command 'Import-Module c:/tmp/Dynamics365Configuration/src/Dynamics365Configuration/RootModule.psm1; Install-Dynamics365Prerequisites;'"
    config.vm.provision "reload"
    config.vm.provision :shell, inline: %Q[powershell -command "[System.Environment]::SetEnvironmentVariable( 'VMDEVOPSSTARTER_DBHOST', 'DB01', [System.EnvironmentVariableTarget]::Machine )"]
end