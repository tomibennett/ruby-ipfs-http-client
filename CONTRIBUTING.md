# Getting a working development environment

## Ipfs

This library uses an ipfs instance inside a Docker container.

### Getting the Docker image

```bash
docker pull ipfs/go-ipfs
```

Then to initialize it, execute the following

```bash
docker run --name ipfsd -p 5001:5001 -d ipfs/go-ipfs
```

or,

```bash
var/bin/ipfsd
```

These commands also start the container.


### Manage the Ipfs daemon lifecycle through Docker

To start it:

```bash
docker start ipfsd
```

To stop it:

```bash
docker stop ipfsd
```

## Ruby

### Rbenv

If you don't have rbenv (or another ruby version manager) already.

To install it:

```bash
git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv
```

Add the following lines in your shell .rc file

```bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

Reload your shell!


### ruby-build

`ruby-build` is an `rbenv` plugin that makes the installation of rubies easier

```bash
mkdir ${HOME}/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build 
```

### Ruby

Go to the root of the project.

You can find the currently used ruby version inside the `.ruby-version` file.

```bash
rbenv install `cat .ruby-version`
rbenv local `cat .ruby-version`
```

This will install and set the correct ruby version to use with the project without
messing up the one that you use in your system.


### The project's dependencies

We go through bundler to install the project dependencies

```sh
gem install bundler
bundle install
```

## Testing the setup

What a better way than running the specs to test if the setup is complete and working.

So, still at the root of the project:

```bash
bundle exec rspec
```

or,

```bash
bundle exec rake test
```