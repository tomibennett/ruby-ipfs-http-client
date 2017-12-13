#!/usr/bin/env bash

install_path=/usr/local
ipfs_version='v0.4.13'

echo 'Downloading ipfs-update, this may take a while...'
[[ ! -d /root/go ]] \
  && ${install_path}/go/bin/go get -u github.com/ipfs/ipfs-update &> /dev/null

echo "Downloading IPFS ${ifps_version}, this may take a while..."
/root/go/bin/ipfs-update install ${ipfs_version}

echo 'init ipfs'
su vagrant -c "${install_path}/bin/ipfs init &> /dev/null"
