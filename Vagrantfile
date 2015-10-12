# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

aws_access_key_id     = ENV.fetch("AWS_ACCESS_KEY_ID", "changeme")
aws_secret_access_key = ENV.fetch("AWS_SECRET_ACCESS_KEY", "changeme")
aws_key_pair_name     = ENV.fetch("AWS_KEY_PAIR_NAME", "changeme")
aws_private_key_path  = ENV.fetch("AWS_PRIVATE_KEY_PATH", "changeme")
aws_region            = ENV.fetch("AWS_REGION", "changeme")
aws_security_group    = ENV.fetch("AWS_SECURITY_GROUP", "changeme")
aws_subnet_id         = ENV.fetch("AWS_SUBNET_ID", "changeme")

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # set to false, if you do NOT want to check the correct VirtualBox Guest Additions version when booting this box
  if defined?(VagrantVbguest::Middleware)
    config.vbguest.auto_update = true
  end

  config.vm.network :forwarded_port, guest: 5601, host: 5601
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 9300, host: 9300

  config.vm.provider :virtualbox do |vb|
      vb.box = "puppetlabs/ubuntu-14.04-64-puppet"
      vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "2048"]
  end

  config.vm.provider "vmware_fusion" do |v, override|
     ## the puppetlabs ubuntu 14-04 image might work on vmware, not tested? 
    v.provision "shell", path: 'ubuntu.sh'
    v.box = "phusion/ubuntu-14.04-amd64"
    v.vmx["numvcpus"] = "2"
    v.vmx["memsize"] = "2048"
  end

  config.vm.provider "aws" do |aws, override|
    override.vm.box = "dummy"

    aws.access_key_id = aws_access_key_id
    aws.secret_access_key = aws_secret_access_key
    aws.keypair_name = aws_key_pair_name

    aws.ami = "ami-69631053" # ubuntu base image
    aws.instance_type = "t2.micro" # coz it's free...

    aws.region = aws_region
    aws.security_groups = [ aws_security_group ]
    aws.subnet_id = aws_subnet_id
    aws.elastic_ip = true

    aws.tags = {
      'Name' => 'elk'
    }

    aws.user_data = File.read("user_data.txt")
    config.ssh.pty = true

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = aws_private_key_path
  end
  
  config.vm.provision "shell", path: 'dumbUbuntu.sh'
  config.vm.provision "shell", path: 'setup.sh'
  config.vm.provision "puppet",  manifest_file: "default.pp"
end
