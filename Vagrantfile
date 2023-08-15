# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  # config.vm.provider "virtualbox" do |v|
  #   v.gui = false
  #   v.memory = 1024
  #   v.cpus = 1
  # end
  
  # ELK Server (Debian 11)
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "merev/debian-11"
    vm1.vm.hostname = "server.lab"
    vm1.vm.network "private_network", ip: "192.168.99.100"
    vm1.vm.synced_folder "shared/", "/shared"
    vm1.vm.provision "shell", path: "initial-config/add_hosts.sh"
    vm1.vm.provision "shell", path: "initial-config/elasticsearch_install.sh"
    vm1.vm.provision "shell", path: "initial-config/logstash_install.sh"
    vm1.vm.provision "shell", path: "initial-config/kibana_install.sh"
    vm1.vm.provision "shell", path: "initial-config/heartbeat_install.sh"
    vm1.vm.provision "shell", path: "initial-config/metricbeat_install.sh"
    # vm1.vm.provision "shell" do |s|
    #   s.path = "initial-config/node_exporter_install.sh"
    #   s.args = ["YES"]
    # end
    vm1.vm.provider "virtualbox" do |v|
      v.gui = false
      v.memory = 3072
      v.cpus = 2
    end
  end

  # Node 1 (Debian 11)
  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "merev/debian-11"
    vm2.vm.hostname = "node1.lab"
    vm2.vm.network "private_network", ip: "192.168.99.101"
    vm2.vm.synced_folder "shared/", "/shared"
    vm2.vm.provision "shell", path: "initial-config/add_hosts.sh"
    vm2.vm.provision "shell", path: "initial-config/metricbeat_install.sh"
    vm2.vm.provision "shell", path: "initial-config/auditbeat_install.sh"
    vm2.vm.provision "shell", path: "initial-config/filebeat_install.sh"
    # vm2.vm.provision "shell", path: "initial-config/docker_install.sh"
    # vm2.vm.provision "shell" do |s|
    #   s.path = "initial-config/node_exporter_install.sh"
    #   s.args = ["YES"]
    # end
    vm2.vm.provider "virtualbox" do |v|
      v.gui = false
      v.memory = 512
      v.cpus = 1
    end
  end

  # # Node 2 (Debian 11)
  # config.vm.define "vm3" do |vm3|
  #   vm3.vm.box = "merev/debian-11"
  #   vm3.vm.hostname = "node2.lab"
  #   vm3.vm.network "private_network", ip: "192.168.99.102"
  #   vm3.vm.synced_folder "shared/", "/shared"
  #   vm3.vm.provision "shell", path: "initial-config/add_hosts.sh"
  #   vm3.vm.provision "shell", path: "initial-config/metricbeat_install.sh"
  #   # vm3.vm.provision "shell", path: "initial-config/docker_install.sh"
  #   # vm3.vm.provision "shell" do |s|
  #   #   s.path = "initial-config/node_exporter_install.sh"
  #   #   s.args = ["NO"]
  #   # end
  #   vm3.vm.provider "virtualbox" do |v|
  #     v.gui = false
  #     v.memory = 512
  #     v.cpus = 1
  #   end
  # end

end
