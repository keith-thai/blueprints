# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version Please don't change 

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provider :virtualbox do |v|
	v.customize ["modifyvm", :id, "--memory", 1024]
	#resolve slow network issues 
	v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  
  #Setup Synced folder 
  #config.vm.synced_folder "C:/Box/git", "/vagrant_data/gitSync"

  # Enable provisioning with a shell script. 
  
  #Install Python and pip
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
	
	#Utils
	apt-get install unzip -y
	apt-get install jq -y
	
	#Python
	apt-get install python-dev python-pip -q -y
	
	#Install AWS cli and boto3
	pip install awscli --upgrade --user
	pip install boto3
	
	#Install Azure CLI
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash	
	
	#Install Terraform
	wget https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.7_linux_amd64.zip
	unzip terraform_0.12.7_linux_amd64.zip
	mv terraform /usr/local/bin/
	terraform --version 
	
  SHELL
  
  # Optional: Use external provisioners,
  #config.vm.provision :shell, :path => "provisioners/bootstrap.sh"
  
  #Install docker
  #config.vm.provision "docker"
 end
