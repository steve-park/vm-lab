# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define "gateway" do |gateway|
    gateway.vm.hostname = "gateway"
    gateway.vm.box = "bento/centos-7.3"

    gateway.vm.network "private_network", ip: "192.168.56.200"

    gateway.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "gateway"
      vb.cpus = 2
      vb.memory = "2048"  
    end

    gateway.vm.provision "shell", path: "./scripts/common.sh"
    gateway.vm.provision "shell", inline: <<-SHELL
      # install ansible
      yum install -y epel-release
      yum install -y ansible
      # add host to ansible inventory
      echo "## ansible-labs servers" >> /etc/ansible/hosts
      echo "[labservers]" >> /etc/ansible/hosts
      echo "192.168.56.101" >> /etc/ansible/hosts
      echo "192.168.56.102" >> /etc/ansible/hosts
    SHELL
    gateway.vm.provision "shell", privileged: false, inline: <<-SHELL
      rm -rf /vagrant/ssh > /dev/null
      mkdir /vagrant/ssh > /dev/null
      # generate RSA secure keys
      ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 
      cp ~/.ssh/id_rsa.pub /vagrant/ssh/
    SHELL
    gateway.vm.provision "shell", run: "always",
      inline: "echo Welcome! Ansible Server is Ready!!"
  end


  (1..2).each do |i|
    config.vm.define "worker-#{i}" do |worker|
      worker.vm.hostname = "worker#{i}"
      
      if i.odd?
        worker.vm.box = "bento/centos-7.3"
      else
        worker.vm.box = "bento/ubuntu-20.04"
      end

      worker.vm.network "private_network", ip: "192.168.56.10#{i}"

      worker.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.name = "worker-#{i}"
        vb.cpus = 2
        vb.memory = "1024"  
      end

      worker.vm.provision "shell", path: "./scripts/common.sh"
      worker.vm.provision "shell", privileged: false, inline: <<-SHELL
        mkdir ~/.ssh > /dev/null
        chmod 700 ~/.ssh > /dev/null
        # add gateway key to authorized_keys for ansible
        cat /vagrant/ssh/id_rsa.pub >> ~/.ssh/authorized_keys
      SHELL
      worker.vm.provision "shell", run: "always",
        inline: "echo Welcome! Ansible Worker-#{i} is Ready!!"
    end
  end

end
