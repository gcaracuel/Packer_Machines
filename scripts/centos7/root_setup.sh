#!/bin/bash

# Basic system preparation
set -e

# Add here all the packeges you need as base (For Guest Additions)
sudo yum install -y wget telnet
sudo yum groupinstall -y "Development Tools"
sudo yum install -y kernel-devel
# Rpmforge is not working for CentOS 7 yet we'll use EPEL repos
#sudo rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
#wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
#sudo rpm -i rpmforge-release-0.5.3-1.el7.rf.*.rpm
#sudo yum --enablerepo rpmforge install -y dkms
sudo rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm;
sudo yum --enablerepo epel install -y dkms

sudo yum install -y vim


# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
