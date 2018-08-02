#!/usr/bin/env bash


sudo yum install -y epel-release
sudo yum makecache fast
sudo yum -y update
sudo yum install -y bash-completion mysql-devel ruby ruby-rdoc  rubygems nodejs qt5-qtwebkit-devel wget libxslt-devel libxml2-devel
#yum install -y gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel
sudo yum install -y bind-utils net-tools git telnet
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test
sudo yum  install -y docker-ce
# Set timezone to Berlin
#ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime


#Start Docker
sudo systemctl start docker
sudo systemctl enable docker
