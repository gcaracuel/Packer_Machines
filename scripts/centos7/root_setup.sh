#!/bin/bash

# Basic system preparation
set -e

# Configure google DNS servers
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Add here all the packages you need as base (For Guest Additions)
sudo yum install -y wget telnet vim bzip2
sudo yum install -y kernel-devel-`uname -r`
sudo yum install -y kernel-headers-`uname -r`


# Next line should be removed after Vagrant solves the problem with: Dynamic network cards https://github.com/mitchellh/vagrant/pull/4195
# It will instal ifconfig and service commands since vagrant is still using
sudo yum groupinstall -y "Base"

# Rpmforge is not working for CentOS 7 yet we'll use EPEL repos
#sudo rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
#wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
#sudo rpm -i rpmforge-release-0.5.3-1.el7.rf.*.rpm
#sudo yum --enablerepo rpmforge install -y dkms
sudo rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm;
sudo yum --enablerepo epel install -y dkms

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
