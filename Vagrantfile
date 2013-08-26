# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

DJANGO_PROJECT_NAME = "{{ project_name }}"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-12.04-omnibus-chef"
  config.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04-omnibus-chef.box"

  config.vm.network :forwarded_port, guest: 8080, host: 8080

  config.ssh.forward_agent = true

  config.berkshelf.enabled = true

  config.omnibus.chef_version = :latest
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.roles_path = "chef/roles"

    chef.json = {
      "twoscoops" => {
        "project_name" => DJANGO_PROJECT_NAME
      } 
    }

    chef.add_role('local')
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key =  ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = "aws-default"

    aws.ami = "ami-d0f89fb9"
    aws.instance_type = "t1.micro"
    #aws.security_groups = ['security-group-name']

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "~/.ssh/aws.pem"
  end
end
