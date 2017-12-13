#! /usr/bin/env bash

rbenv_root="${HOME}/.rbenv"

if [[ ! -d ${rbenv_root} ]]
then
  echo 'Downloading rbenv...'
  git clone https://github.com/rbenv/rbenv.git ${rbenv_root} &> /dev/null

  [[ ! `echo ${PATH} | grep '.rbenv'` ]] \
    && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

  echo 'Downloading ruby-build...'
  [[ ! -d ${rbenv_root}/plugins ]] \
    && mkdir -p ${rbenv_root}/plugins \
    && git clone https://github.com/rbenv/ruby-build.git ${rbenv_root}/plugins/ruby-build &> /dev/null

  echo 'Installing ruby...'
  ${rbenv_root}/bin/rbenv install `cat ${HOME}/ruby-ipfs-api/.ruby-version` &> /dev/null
  ${rbenv_root}/bin/rbenv global `cat ${HOME}/ruby-ipfs-api/.ruby-version` &> /dev/null
fi
