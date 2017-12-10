# Getting a working development environment

## Getting the tools

Install `virtualbox` and `vagrant`.

From that point, just install the `vbguest` otherwise the repo will
not be shared with the vm.

```sh
vagrant plugin install vagrant-vbguest
```

An then at the project's root,

```sh
vagrant up
```

is sufficient as everything else is provisioned by Vagrant.


## The project

Inside the guest at the project's root (`${HOME}/ruby-ipfs-api`)

```sh
gem install bundler
bundle install
```
