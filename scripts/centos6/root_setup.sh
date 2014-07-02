#!/bin/bash

# Basic system preparation
set -e

# Add here all the packeges you need as base (For Guest Additions)
sudo yum install -y wget telnet
yum groupinstall -y "Development Tools"
yum install -y kernel-devel
sudo rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
sudo rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm
sudo yum --enablerepo rpmforge install -y dkms


# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
