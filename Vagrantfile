# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "CentOS-6.3-x86_64-minimal"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://dl.dropbox.com/u/7225008/Vagrant/CentOS-6.3-x86_64-minimal.box"

  # Puppet Master, Puppet DB, PostgreSQL machine
  config.vm.define "puppetdb" do |puppetdb|
      # Shell provisioner
      puppetdb.vm.provision "shell", path: "provision/puppetdb.sh"

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      puppetdb.vm.network :private_network, ip: "192.168.33.10"

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine.
      puppetdb.vm.network :forwarded_port, guest: 8080, host: 8080  # Puppet DB dashboard
      puppetdb.vm.network :forwarded_port, guest: 8081, host: 8081  # Puppet DB API with SSL
  end

  config.vm.define "puppetboard" do |puppetboard|
      # Shell provisioner
      puppetboard.vm.provision "shell", path: "provision/puppetboard.sh"

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      puppetboard.vm.network :private_network, ip: "192.168.33.11"

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine.
      puppetboard.vm.network :forwarded_port, guest: 5000, host: 5000  # Puppetboard web app
  end

  config.vm.define "dashboard" do |dashboard|
      # Shell provisioner
      dashboard.vm.provision "shell", path: "provision/dashboard.sh"

      # Create a private network, which allows host-only access to the machine
      # using a specific IP.
      dashboard.vm.network :private_network, ip: "192.168.33.12"

      # Create a forwarded port mapping which allows access to a specific port
      # within the machine from a port on the host machine.
      dashboard.vm.network :forwarded_port, guest: 3030, host: 3030  # Dashboard web app
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
end
