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

# Add here all the packages you need as base (For Guest Additions)
yum install -y wget telnet vim
yum install -y kernel-devel-`uname -r`
yum install -y kernel-headers-`uname -r`

rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm
yum --enablerepo rpmforge install -y dkms
rm -rf /home/vagrant/rpmforge-release-0.5.3-1.el6.rf.*.rpm

#Installing Virtualbox guest additions
mkdir /tmp/vbox
VER=$(cat /home/vagrant/.vbox_version)
mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox

# Return always true (exit code 0) to avoid bug in additions when no X.org
sh -c "/tmp/vbox/VBoxLinuxAdditions.run; true"
umount /tmp/vbox
rmdir /tmp/vbox
rm /home/vagrant/*.iso


##### PUT HERE YOUR STUFF


## Docker kernel
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh epel-release-6*.rpm

echo "Install docker:"
yum install -y docker-io
chkconfig docker on

#echo "Add cgroup to fstab"
#echo "none                    /sys/fs/cgroup          cgroup  defaults        0 0" >> /etc/fstab

#echo "Install custom docker kernel:"
#rpm -iUvh http://tsuru.s3.amazonaws.com/centos/kernel-ml-aufs-3.10.11-1.el6.x86_64.rpm

#echo "Make sure to boot the docker kernel."
#sed -i s/default=1/default=0/g /boot/grub/menu.lst
#sed -i s/default=1/default=0/g /boot/grub/grub.conf

echo "Set IP forwarding permanetly:"
sed 's/net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/g' /etc/sysctl.conf


#####

# Cleanup
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all

# Remove traces of mac address from network configuration
sed -i /HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
rm /etc/udev/rules.d/70-persistent-net.rules

date > /etc/vagrant_box_build_time