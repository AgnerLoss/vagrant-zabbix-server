Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.name = "vagrant-zabbix-server"
    vb.memory = 2048
    vb.cpus = 2
end
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "public_network", ip: "192.168.100.160", bridge: "eno1"
  config.vm.provision "shell", path: "script.sh"  
end

