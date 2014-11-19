#!/bin/bash

# Basic system preparation
set -e

# Set up sudo
sudo echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Configure google DNS servers
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf

sudo apt-get -y update && apt-get -y upgrade
sudo apt-get -y install linux-image-generic-lts-raring linux-headers-generic-lts-raring build-essential curl wget module-assistant


# Installing vagrant keys
sudo mkdir /home/vagrant/.ssh
sudo chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
sudo wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
sudo chmod 600 /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh


# Installing  Virtualbox guest additions
sudo mkdir /mnt/VBoxGuestAdditions
VER=$(cat /home/vagrant/.vbox_version)
sudo mount /home/vagrant/VBoxGuestAdditions_$VER.iso /mnt/VBoxGuestAdditions
sudo sh -c "/mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run ; true"
sudo umount /mnt/VBoxGuestAdditions
sudo rmdir /mnt/VBoxGuestAdditions
sudo rm /home/vagrant/VBoxGuestAdditions_*.iso


##### DO IT HERE YOUR STUFF





#####

## clean up the install
sudo apt-get dist-upgrade -y
sudo apt-get clean

date > /etc/vagrant_box_build_time