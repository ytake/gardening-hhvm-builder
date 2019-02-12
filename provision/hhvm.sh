#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# installs add-apt-repository
sudo apt-get update
sudo apt-get install software-properties-common apt-transport-https
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xB4112585D386EB94

sudo add-apt-repository https://dl.hhvm.com/ubuntu
sudo apt-get update
sudo apt-get -y --allow-unauthenticated install hhvm

# Configure HHVM

service hhvm stop
sed -i 's/#RUN_AS_USER="www-data"/RUN_AS_USER="vagrant"/' /etc/default/hhvm
service hhvm start

# Start HHVM On System Start

update-rc.d hhvm defaults

echo "hhvm.server.user = vagrant" >> /etc/hhvm/server.ini
echo "hhvm.log.header = true" >> /etc/hhvm/server.ini
echo "hhvm.debug.server_error_message = true" >> /etc/hhvm/server.ini
echo "display_errors = On" >> /etc/hhvm/server.ini
echo "html_errors = On" >> /etc/hhvm/server.ini
echo "error_reporting = 22527" >> /etc/hhvm/server.ini
echo "hhvm.server.fix_path_info = true" >> /etc/hhvm/server.ini

sed -i "s|date.timezone.*|date.timezone = Asia\/Tokyo|" /etc/hhvm/server.ini
sed -i "s|hhvm.server.port = 9001|hhvm.server.port = 9000|g" /etc/hhvm/server.ini

# Install Composer

curl -sS https://getcomposer.org/installer | hhvm --php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path

printf "\nPATH=\"$(sudo su - vagrant -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile

