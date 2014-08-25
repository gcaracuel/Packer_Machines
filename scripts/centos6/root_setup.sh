#!/bin/bash

# Basic system preparation
set -e

# Configure google DNS servers
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Add here all the packages you need as base (For Guest Additions)
sudo yum install -y wget telnet vim
sudo yum install -y kernel-devel-`uname -r`
sudo yum install -y kernel-headers-`uname -r`

sudo rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
sudo rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm
sudo yum --enablerepo rpmforge install -y dkms
sudo rm -rf /home/vagrant/rpmforge-release-0.5.3-1.el6.rf.*.rpm

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