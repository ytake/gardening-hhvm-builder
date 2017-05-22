#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# installs add-apt-repository
sudo apt-get install software-properties-common

sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
sudo add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get install -y hhvm

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
echo "hhvm.php7.all = true" >> /etc/hhvm/server.ini

sed -i "s|date.timezone.*|date.timezone = Asia\/Tokyo|" /etc/hhvm/server.ini
sed -i "s|hhvm.server.port = 9001|hhvm.server.port = 9000|g" /etc/hhvm/server.ini

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path

printf "\nPATH=\"$(sudo su - vagrant -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile

sudo su vagrant <<'EOF'
/usr/local/bin/composer global require "hirak/prestissimo:^0.3"
EOF
