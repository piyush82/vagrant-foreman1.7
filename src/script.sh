#!/bin/bash

# enabling the latest puppet release repo
# apt-get -y install ca-certificates
# wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
# dpkg -i puppetlabs-release-trusty.deb

# enabling the foreman repo
echo "deb http://deb.theforeman.org/ trusty 1.7" > /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 1.7" >> /etc/apt/sources.list.d/foreman.list
wget -q http://deb.theforeman.org/pubkey.gpg -O- | apt-key add -

# downloading the foreman installer
apt-get update && apt-get -y install foreman-installer

# getting the correct rubygem apiapi version
# gem install apipie-bindings --version=0.0.8

# removing any existing foreman-answers yaml file
rm /etc/foreman/foreman-installer-answers.yaml

# replace with a predefined answers filr
cp /tmp/files-to-go/foreman-installer-answers.yaml /etc/foreman/foreman-installer-answers.yaml

# install foreman in non-interactive mode
foreman-installer

# copy the discovery template in the target folder
cp /tmp/files-to-go/default /var/lib/tftpboot/pxelinux.cfg/

# now downloading the correct discovery images
echo "Downloading the discovery images now. Please be patient ..."
wget --timeout=10 --tries=3 --quiet --no-check-certificate -nv -c "http://downloads.theforeman.org/discovery/releases/latest/foreman-discovery-image-3.0.5-20140523.0.el6.iso-vmlinuz" -O "/var/lib/tftpboot/boot/vmlinuz0"
wget --timeout=10 --tries=3 --quiet --no-check-certificate -nv -c "http://downloads.theforeman.org/discovery/releases/0.5/foreman-discovery-image-3.0.5-20140523.0.el6.iso-img" -O "/var/lib/tftpboot/boot/initrd0.img"
echo "Now downloading the ubuntu images. Please be patient ..."
wget --timeout=10 --tries=3 --quiet --no-check-certificate -nv -c "http://archive.ubuntu.com/ubuntu//dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz" -O "/var/lib/tftpboot/boot/Ubuntu-12.04-x86_64-initrd.gz"
wget --timeout=10 --tries=3 --quiet --no-check-certificate -nv -c "http://archive.ubuntu.com/ubuntu//dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux" -O "/var/lib/tftpboot/boot/Ubuntu-12.04-x86_64-linux"
