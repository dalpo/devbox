# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = 'debian/stretch64'
  # config.vm.box_version = '9.7.0'
  config.vm.box = 'ubuntu/bionic64'

  config.disksize.size = ENV.fetch('DEVBOX_DISKSIZE', '50GB')

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing 'localhost:8080' will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network 'forwarded_port', guest: 80, host: 8080
  
  config.vm.network 'forwarded_port', guest: 3000, host: 80
  
  [3000, 4000, 4567, 5000, 5100, 9090, 8080, 3035, 3333].each do |port|
    config.vm.network 'forwarded_port', guest: port, host: port
  end

  config.vm.hostname = ENV.fetch('HOSTNAME', 'd3vb0x.local')
  config.vm.network :private_network, ip: ENV.fetch('LOCAL_NETWORK_IP', '192.168.99.99')
  
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network 'forwarded_port', guest: 80, host: 8080, host_ip: '127.0.0.1'

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network 'private_network', ip: '192.168.33.10'

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network 'public_network'

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder '.', '/vagrant', disabled: false
  
  config.nfs.map_uid = Process.uid
  config.nfs.map_gid = Process.gid
  config.vm.synced_folder \
    '../workspace', '/workspace', 
    nfs: true, create: true,
    mount_options: ['rw', 'vers=3', 'tcp'],
    linux__nfs_options: ['rw',' no_subtree_check', 'all_squash', 'async']

  config.ssh.insert_key = true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = ENV.fetch('DEVBOX_MEMORY', 8192).to_i
    cpus = ENV.fetch('DEVBOX_CPUS', 6).to_i
    vb.cpus = cpus

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ['modifyvm', :id, '--name', 'd3vb0x']
    vb.customize ['modifyvm', :id, '--vram', ENV.fetch('DEVBOX_VMEMORY', 256)]
    vb.customize ['modifyvm', :id, '--accelerate3d', 'on']
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision 'shell', inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.vm.provision "shell" do |s|
    ssh_prv_key = ""
    ssh_pub_key = ""
    ssh_config = ""

    if File.file?("#{Dir.home}/.ssh/id_rsa")
      ssh_prv_key = File.read("#{Dir.home}/.ssh/id_rsa")
      ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    else
      puts "No SSH key found. You will need to remedy this before pushing to the repository."
    end

    if File.file?("#{Dir.home}/.ssh/config")
      ssh_config = File.read("#{Dir.home}/.ssh/config")
    end
 
    s.inline = <<-SHELL
      sudo apt install -y python virtualenv

      if grep -sq "#{ssh_pub_key}" /home/vagrant/.ssh/authorized_keys; then
        echo "SSH keys already provisioned."
        exit 0;
      fi
      
      echo "SSH key provisioning."
      mkdir -p /home/vagrant/.ssh/
      touch /home/vagrant/.ssh/authorized_keys
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      
      touch /home/vagrant/.ssh/config
      echo #{ssh_config} > /home/vagrant/.ssh/config
      chmod 644 /home/vagrant/.ssh/config

      echo #{ssh_pub_key} > /home/vagrant/.ssh/id_rsa.pub
      chmod 644 /home/vagrant/.ssh/id_rsa.pub

      echo "#{ssh_prv_key}" > /home/vagrant/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/id_rsa

      chown -R vagrant:vagrant /home/vagrant
      exit 0
    SHELL
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'ansible/playbook.yml'
    ansible.verbose = true
  #   # ansible.vault_password_file = VAULT_PASSWORD_FILE
  #   # ansible.extra_vars = {
  #   #   rename_hostname: false
  #   # }
  end
end
