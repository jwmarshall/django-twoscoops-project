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

    chef.json = {
      "postgresql" => {
        "password" => {
          "postgres" => "vagrant"
        }
      },
      "twoscoops" => {
        "project_name" => DJANGO_PROJECT_NAME,
        "database" => {
          "engine" => "django.db.backends.psycopg2",
          "username" => "postgres",
          "password" => "vagrant"
        }
      } 
    }

    chef.run_list = [
      "apt",
      "build-essential",
      "postgresql::server",
      "python",
      "supervisor",
      "twoscoops"
    ]
  end
end
