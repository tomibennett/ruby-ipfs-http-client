#! /usr/bin/env bash

project_root=/home/vagrant/ruby-ipfs-api

# Set the clock

# Set motd
cat > /etc/motd <<EOF
Hi,

Just to tell you, this VM is only for testing purpose, and thus
you'll be running an offline version of IPFS
EOF


# Updating the package manager, repositories and ruby dependencies
echo 'Updating packages manager, repositories and ruby dependencies...'
apt-get -y update
apt-get -y upgradie
apt-get -y install libssl-dev libreadline-dev zlib1g-dev g++ git
apt-get -y autoremove


# Getting Ipfs dependencies - golang
${project_root}/var/bin/install_go.sh


# and IPFS itself
${project_root}/var/bin/install_ipfs.sh


# Downloading && installing ruby
su vagrant -c "${project_root}/var/bin/install_ruby.sh"

# enable ipfs daemon at startup
# cp ${project_root}/var/conf/ipfs_upstart.conf /etc/init/ipfs.conf
