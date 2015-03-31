# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "Centos-6.5"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"
  config.vm.hostname = "vg-scala"

  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.network "forwarded_port", guest: 8080, host: 18080
  config.vm.network "forwarded_port", guest: 8888, host: 18888
  config.vm.network "forwarded_port", guest: 9000, host: 19000
  config.vm.network "forwarded_port", guest: 3306, host: 13306
  config.vm.network "forwarded_port", guest: 9900, host: 19900
  
  config.vm.network :private_network, ip: "10.0.79.102"
  config.vm.synced_folder "../../workspace", "/workspace", :type => "nfs"
  config.vm.synced_folder "~/.sbt", "/home/vagrant/.sbt", :type => "nfs"
  config.vm.synced_folder "~/.ivy2", "/home/vagrant/.ivy2", :type => "nfs"

  config.vm.provider :virtualbox do |vb|
    vb.name = "devenv.scala"
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "2", "--ioapic", "on"]
  end
  
  config.ssh.forward_agent = true
  #config.ssh.private_key_path = "~/.ssh/id_rsa"
end

