VAGRANT_NODES = {
  "controller" => "10.0.0.1",
  "compute1"   => "10.0.0.2",
  "compute2"   => "10.0.0.3"
}

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  VAGRANT_NODES.each do |name, ip|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: ip
      node.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.cpus = 1
      end
      node.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y python3 python3-pip openssh-server
      SHELL
    end
  end
end