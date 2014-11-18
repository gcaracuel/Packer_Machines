#!/bin/bash

# Basic system preparation
set -e

# Configure google DNS servers
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Installing vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
curl -o /home/vagrant/.ssh/authorized_keys 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' 
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config

# Next line should be removed after Vagrant solves the problem with: Dynamic network cards https://github.com/mitchellh/vagrant/pull/4195
# It will instal ifconfig and service commands since vagrant is still using
yum groupinstall -y "Base"

# Add here all the packages you need as base (For Guest Additions)
yum install -y wget telnet vim
yum install -y kernel-devel-`uname -r`
yum install -y kernel-headers-`uname -r`

# Rpmforge is not working for CentOS 7 yet we'll use EPEL repos
#sudo rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
#wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
#sudo rpm -i rpmforge-release-0.5.3-1.el7.rf.*.rpm
#sudo yum --enablerepo rpmforge install -y dkms
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm;
yum --enablerepo epel install -y dkms

#Installing  Virtualbox guest additions
mkdir /tmp/vbox
VER=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox

# Return always true (exit code 0) to avoid bug in additions when no X.org
sh -c "/tmp/vbox/VBoxLinuxAdditions.run; true"
umount /tmp/vbox
rmdir /tmp/vbox
rm /home/vagrant/*.iso


##### PUT HERE YOUR STUFF

yum install -y docker

#####

# Cleanup
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all

# Remove traces of mac address from network configuration
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm /etc/udev/rules.d/70-persistent-net.rules

date > /etc/vagrant_box_build_time