#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Update Package List
apt-get update

# Install Kernel Headers

apt-get install -y linux-headers-$(uname -r) build-essential

# Upgrade System Packages

apt-get -y upgrade

echo "LC_ALL=ja_JP.UTF-8" >> /etc/default/locale
locale-gen ja_JP.UTF-8
sudo /usr/sbin/update-locale LANG=ja_JP.UTF-8


apt-get install -y software-properties-common curl

apt-add-repository ppa:nginx/development -y
apt-add-repository ppa:chris-lea/redis-server -y

curl -s https://packagecloud.io/gpg.key | apt-key add -

apt-get update

# Install Some Basic Packages

apt-get install -y build-essential dos2unix gcc git libmcrypt4 libpcre3-dev ntp unzip \
make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim libnotify-bin \
pv cifs-utils

sudo ln -sf /usr/share/zoneinfo/Japan /etc/localtime
