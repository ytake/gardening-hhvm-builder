#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get -y update
sudo apt-get -y dist-upgrade

# node.js install 7.*
curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -

# Install Node

sudo apt-get install -y nodejs
sudo apt-get install -y npm

NPM_CONFIG=`npm config get prefix`
if [ $NPM_CONFIG = '/usr' ]; then
 mkdir ~/.npm-global
 echo "export NPM_CONFIG_PREFIX=~/.npm-global" >> /home/vagrant/.bash_profile
fi

/usr/bin/npm install -g gulp
/usr/bin/npm install -g yarn
/usr/bin/npm install -g webpack
/usr/bin/npm install -g nuclide
