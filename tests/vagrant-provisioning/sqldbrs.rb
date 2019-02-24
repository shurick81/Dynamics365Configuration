Vagrant.configure(2) do |config|
    config.vm.provision :shell, path: "../../../../infrastructure/images/basepsmodules.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/images/sqlpsmodules.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/images/domainclientpsmodules.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/domainclientnetwork.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/domainclient.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/xcredclient.ps1"
    config.vm.provision "reload"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/crmdomainclientgroups.ps1", env: { "SPDEVOPSSTARTER_TRIALS" => 100 }
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/dbservernamefix.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/sqlconfig.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/rsconfig.ps1"
    config.vm.provision :shell, path: "../../../../infrastructure/stacks/rsserviceaccountupdate.ps1"
    config.vm.provision :file, source: "../../../../src", destination: "c:/tmp/Dynamics365Configuration/src"
    config.vm.provision :shell, inline: "powershell -command 'Import-Module c:/tmp/Dynamics365Configuration/src/Dynamics365Configuration/Dynamics365Configuration.psd1; Install-Dynamics365Prerequisite;'"
    config.vm.provision "reload"
end