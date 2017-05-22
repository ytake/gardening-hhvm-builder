# -*- mode: ruby -*-
# vi: set ft=ruby :

Encoding.default_external = 'UTF-8'

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure The Box
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.hostname = 'gardening-hhvm'

  # Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

  # Configure Port Forwarding
  config.vm.network 'forwarded_port', guest: 80, host: 8000, auto_correct: true
  config.vm.network 'forwarded_port', guest: 3306, host: 33060, auto_correct: true
  config.vm.network 'forwarded_port', guest: 5432, host: 54320, auto_correct: true
  config.vm.network 'forwarded_port', guest: 35729, host: 35729, auto_correct: true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.provision 'shell', path: './provision/update.sh'
  config.vm.provision 'shell', path: './provision/nodejs.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/database.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/servers.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/hhvm.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/end.sh'
end
