#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install SQLite

apt-get install -y sqlite3 libsqlite3-dev

# Install MySQL

debconf-set-selections <<< "mysql-server mysql-server/root_password password 00:secreT,@"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 00:secreT,@"
apt-get install -y mysql-server

# Configure MySQL Password Lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Configure MySQL Remote Access

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="00:secreT,@" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY '00:secreT,@' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" --password="00:secreT,@" -e "CREATE USER 'gardening'@'0.0.0.0' IDENTIFIED BY '00:secreT,@';"
mysql --user="root" --password="00:secreT,@" -e "GRANT ALL ON *.* TO 'gardening'@'0.0.0.0' IDENTIFIED BY '00:secreT,@' WITH GRANT OPTION;"
mysql --user="root" --password="00:secreT,@" -e "GRANT ALL ON *.* TO 'gardening'@'%' IDENTIFIED BY '00:secreT,@' WITH GRANT OPTION;"
mysql --user="root" --password="00:secreT,@" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="00:secreT,@" -e "CREATE DATABASE gardening character set UTF8mb4 collate utf8mb4_general_ci;"
service mysql restart

# Add Timezone Support To MySQL

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql

# Install Postgres

apt-get install -y postgresql

# Configure Postgres Remote Access

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.5/main/postgresql.conf
echo "host    all             all             10.0.2.2/32               md5" | tee -a /etc/postgresql/9.5/main/pg_hba.conf
sudo -u postgres psql -c "CREATE ROLE gardening LOGIN UNENCRYPTED PASSWORD '00:secreT,@' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
sudo -u postgres /usr/bin/createdb --echo --owner=gardening gardening
service postgresql restart

# Install The Chrome Web Driver & Dusk Utilities

apt-get -y install libxpm4 libxrender1 libgtk2.0-0 \
libnss3 libgconf-2-4 chromium-browser \
xvfb gtk2-engines-pixbuf xfonts-cyrillic \
xfonts-100dpi xfonts-75dpi xfonts-base \
xfonts-scalable imagemagick x11-apps

# Install Memcached & Beanstalk

apt-get install -y redis-server memcached

# Configure Supervisor

systemctl enable supervisor.service
service supervisor start

# Clean Up

apt-get -y autoremove
apt-get -y clean

# Enable Swap Memory

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# Minimize The Disk Image

echo "Minimizing disk image..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync
