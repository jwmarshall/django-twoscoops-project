# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

DJANGO_PROJECT_NAME = "{{ project_name }}"
CHEF_JSON = {
  "build-essential" => {
    "compiletime" => true
  },
  "postgresql" => {
    "password" => {
      "postgres" => "vagrant"
    },
    "config" => {
      "client_encoding" => "UTF8",
      "default_transaction_isolation" => "read committed",
      "timezone" => "UTC"
    }
  },
  "twoscoops" => {
    "application_name" => DJANGO_PROJECT_NAME,
    "project_name" => DJANGO_PROJECT_NAME,
    "database" => {
      "engine" => "django.db.backends.postgresql_psycopg2",
       "username" => "postgres",
       "password" => "vagrant"
    }
  }
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-12.04-omnibus-chef"
  config.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04-omnibus-chef.box"

  config.vm.network :forwarded_port, guest: 8080, host: rand(30000) + 1024
  config.ssh.forward_agent = true

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  # DEFAULT BOX
  config.vm.define :default do |default|
    default.vm.provision :chef_solo do |chef|
      chef.node_name = DJANGO_PROJECT_NAME
      chef.json = CHEF_JSON

      chef.run_list = [
        "build-essential",
        "postgresql::server",
        "python",
        "supervisor",
        "twoscoops"
      ]
    end
  end

  # TEST BOX
  config.vm.define :test do |test|
    test.vm.provision :chef_solo do |chef|
      chef.node_name = DJANGO_PROJECT_NAME
      chef.json = CHEF_JSON

      chef.run_list = [
        "build-essential",
        "postgresql::server",
        "python",
        "supervisor",
        "twoscoops::test"
      ]
    end
  end

  # REMOTE AWS BOX
  config.vm.define :test do |remote|
    remote.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
      aws.secret_access_key =  ENV['AWS_SECRET_ACCESS_KEY']
      aws.keypair_name = "aws-default"

      aws.ami = "ami-d0f89fb9"
      aws.instance_type = "t1.micro"
      aws.security_groups = ['twoscoops-project']

      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = "~/.ssh/aws.pem"

      override.vm.provision :chef_solo do |chef|
        chef.node_name = DJANGO_PROJECT_NAME
        chef.json = CHEF_JSON

        chef.run_list = [
          "build-essential",
          "postgresql::server",
          "python",
          "supervisor",
          "twoscoops::deploy"
        ]
      end
    end
  end

end
