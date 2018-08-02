
# This Vagrantfile can be used to setup virtuablboxes using Vagrant.
#You can run Vagrant commands two Mode's 'Manual and Auto Mode' by passing arugment to "Vagrant Up"
# Auto mode  Setup two virtual(Manager + 1 Worker node) boxes for you with Docker Swarm pre-installed and configured.
#Eg . AUTO=true vagrant up
# Pre-Requiste - Make sure you have Oracle virtualbox installed on you meachine.



#Auto Mode Env variable
auto = ENV['AUTO'] || false


# Increase numworkers if you want more than 3 nodes
numworkers = 1

#Assign IP for instances
instances = []

(1..numworkers).each do |n|
  instances.push({:name => "docker0#{n}", :ip => "192.168.10.#{n+2}"})
end

manager_ip = "192.168.10.10"

#Create host file in shared vagrant folders.This file will be copied to hosts during VM configuration and
File.open("./hosts", 'w') { |file|
  instances.each do |i|
    file.write("#{i[:ip]} #{i[:name]} #{i[:name]}\n")
  end
}



#Add User's to Docker  and Sudo Group

$add_user_grp_script = <<SCRIPT
  sudo usermod -aG docker vagrant
  sudo usermod -aG wheel vagrant
  sudo echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
SCRIPT


#Clone Capistrano Repo  

$git_clone_capistrano = <<SCRIPT
  echo "Initializing git "
  git init
  git remote -v
 if [ $? -eq "0" ];then
  git clone  git@github.com:pprashanth/capistrano.git /home/vagrant/capistrano
 else
  echo " Unable to connect Git.Ensure you have add the SSH key "
 fi

SCRIPT


Vagrant.configure("2") do |config|
    config.vm.define "manager" do |i|
    config.vm.provider "virtualbox" do |v|
        v.memory = 6048  #Assign the memmory according to your available resource
        v.cpus = 3       #Assign CPU according to your available resource
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    end
      i.vm.box = "centos/7"
      i.vm.hostname = "manager"
      i.vm.network "private_network", ip: "#{manager_ip}", netmask: "255.255.0.0"
      i.ssh.forward_agent = true
      i.ssh.insert_key = false
      i.vm.provision "shell", path: "OS.sh" #This script Install required packages on Operating System
      i.vm.provision "shell", inline: $add_user_grp_script, privileged: true


    # Forward the :80 :8080 :8081 8082 and :443 ports to the host machine.
      i.vm.network :forwarded_port, guest: 80, host: 80, host_ip: "127.0.0.1"


    #Copy host entry to the VM
      if File.file?("./hosts")
        i.vm.provision "file", source: "hosts", destination: "/tmp/hosts"
        i.vm.provision "shell", inline: "sudo cat /tmp/hosts >> /etc/hosts", privileged: true
      end
    #Enable Synced Folder on your vagrant Boxes.
      if auto
        i.vm.synced_folder ".", "/vagrant", type: "nfs"
    #Initializing Docker Swarm
        i.vm.provision "shell", inline: "sudo docker swarm init --advertise-addr #{manager_ip}"
        i.vm.provision "shell", inline: "sudo docker swarm join-token -q worker > /vagrant/token"
        i.vm.provision "shell", inline: "sudo systemctl restart docker"

	#§i.vm.provision "shell", inline: "sudo docker node update --availability drain manager"

      end
    end

  instances.each do |instance|
    config.vm.define instance[:name] do |i|
    config.vm.provider "virtualbox" do |v|
        v.memory = 6048
        v.cpus = 3
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    end
      i.vm.box = "centos/7"
      #i.vm.box_version = "7.0"
      i.vm.hostname = instance[:name]
      i.vm.network "private_network", ip: "#{instance[:ip]}", netmask: "255.255.0.0"
      i.ssh.forward_agent = true
      i.ssh.insert_key = false
      i.vm.provision "shell", path: "OS.sh"
      i.vm.provision "shell", inline: $add_user_grp_script, privileged: true

      if File.file?("./hosts")
        i.vm.provision "file", source: "hosts", destination: "/tmp/hosts"
        i.vm.provision "shell", inline: "cat /tmp/hosts >> /etc/hosts", privileged: true
      end
      if auto
        i.vm.synced_folder ".", "/vagrant", type: "nfs"
        i.vm.provision "shell", inline: "sudo docker swarm join --token `cat /vagrant/token` #{manager_ip}:2377"
        i.vm.provision "shell", inline: "sudo systemctl restart docker"
      end
    end
  end
end
