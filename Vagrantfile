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
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unzip|grep "install ok installed")
	echo Checking for unzip: $PKG_OK
	if [ "" == "$PKG_OK" ]; then
		echo "No unzip. Setting up"
		sudo apt-get --force-yes --yes install unzip
	fi
	
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' jq|grep "install ok installed")
	echo Checking for jq: $PKG_OK
	if [ "" == "$PKG_OK" ]; then
		echo "No jq. Setting up"
		sudo apt-get --force-yes --yes install jq
	fi	
	
	#apt-get install unzip -y
	#apt-get install jq -y
	
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' python-dev|grep "install ok installed")
	echo Checking for python-dev: $PKG_OK
	if [ "" == "$PKG_OK" ]; then
		echo "No python-dev. Setting up"
		sudo apt-get --force-yes --yes install python-dev python-pip
	fi	
	
	#Python
	#apt-get install python-dev python-pip -q -y
	
	#Install AWS cli and boto3
	echo "Checking for awscli"
	PKG_OK=$(command -v aws)
	echo "Checking for aws-cli": $PKG_OK
	if ! [ -x "$PKG_OK" ]; then	
		pip install awscli --upgrade
		pip install boto3
	fi
	#Install Azure CLI
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' azure-cli|grep "install ok installed")
	echo Checking for azure-cli: $PKG_OK
	if [ "" == "$PKG_OK" ]; then
		echo "No azure-cli. Setting up"
		curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash	
	fi		
	
	#Install Terraform v 12.7
	PKG_OK=$(command -v terraform)
	echo "Checking for terraform": $PKG_OK
	if ! [ -x "$PKG_OK" ]; then
		#Install Terraform
		echo "No Terraform. Setting up"
		wget https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.7_linux_amd64.zip
		unzip terraform_0.12.7_linux_amd64.zip
		mv terraform /usr/local/bin/
		terraform --version 
	fi	
	
	#Install Ansible
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ansible|grep "install ok installed")
	echo Checking for ansible: $PKG_OK
	if [ "" == "$PKG_OK" ]; then
		echo "No ansible. Setting up"
		sudo apt install software-properties-common
		sudo apt-add-repository ppa:ansible/ansible -y
		sudo apt update
		sudo apt install ansible --force-yes --yes
	fi		
	
  SHELL
  
  # Optional: Use external provisioners,
  #config.vm.provision :shell, :path => "provisioners/bootstrap.sh"
  
  #Install docker
  #config.vm.provision "docker"
 end
