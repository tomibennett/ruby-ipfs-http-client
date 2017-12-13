#!/usr/bin/env bash

golang_version='1.9.2'
golang_checksum='de874549d9a8d8d8062be05808509c09a88a248e77ec14eb77453530829ac02b'
golang_package=go${golang_version}.linux-amd64.tar.gz
golang_install_path=/usr/local
go_path='export GOPATH=${HOME}/go'
golang_export_path='export PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"'

cat > /tmp/${golang_package}_checksum <<EOF
${golang_checksum}  /tmp/${golang_package}
EOF

while [[ ! -d ${golang_install_path}/go ]]
do
  echo 'Downloading go, this may take a while...'
  wget \
    "https://redirector.gvt1.com/edgedl/go/${golang_package}" \
    -O /tmp/${golang_package} \
    &> /dev/null

  echo 'Checking go installation...'

  [[ ! `shasum -a 256 -c /tmp/${golang_package}_checksum &> /dev/null` ]] \
    && tar -C ${golang_install_path} -xzf /tmp/${golang_package}
done

[[ ! `grep "go/bin" ${HOME}/.bashrc` ]] \
  && echo ${go_path} >> ${HOME}/.bashrc \
  && echo ${golang_export_path} >> ${HOME}/.bashrc
