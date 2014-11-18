#!/bin/bash

# Basic system preparation
set -e

# Configure google DNS servers
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Add here all the packages you need as base (For Guest Additions)
sudo apt-get install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r) curl wget 

# Set up sudo
sudo echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh


#Installing  Vritualbox guest additions
mkdir /tmp/vbox
VER=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox
# Return always true (exit code 0) to avoid bug in additions when no X.org
sh -c "/tmp/vbox/VBoxLinuxAdditions.run; true"
tail /var/log/vboxadd-install.log
umount /tmp/vbox
rmdir /tmp/vbox
rm /home/vagrant/*.iso


## clean up the install
apt-get dist-upgrade -y
apt-get clean

date > /etc/vagrant_box_build_time