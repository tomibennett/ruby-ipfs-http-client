[![Gem Version](https://badge.fury.io/rb/ruby-ipfs-api.svg)](https://badge.fury.io/rb/ruby-ipfs-api)
[![Build Status](https://travis-ci.org/tbenett/ruby-ipfs-api.svg?branch=master)](https://travis-ci.org/tbenett/ruby-ipfs-api)
[![Coverage Status](https://coveralls.io/repos/github/tbenett/ruby-ipfs-api/badge.svg?branch=master)](https://coveralls.io/github/tbenett/ruby-ipfs-api?branch=master)

# ipfs-api

> A client library for the IPFS HTTP API, implemented in Ruby.

Summary:


1. Client
2. File objects
3. Clients related information (debugging purposes)


## Client

Make sure the Ipfs daemon is running, otherwise
the client will not be able to connect.

You'll get an error `Ipfs::UnreachableDaemon` and the program
execution will stop if no daemon are present.

The client will make a persistent connection to the API.

To access the library from your source file:

```ruby
require 'ipfs_api'
```

> TODO: use a configuration file and/or environment variables to specify the http api url. 
Those are hard-coded at the moment :(

## File objects

You can manipulates files through Ipfs with the `Ipfs::File` class.

### Instantiation

To create a file, just pass a path

```ruby
file = Ipfs::File.new('path/to/file')
```

This will instantiate a new `Ipfs::File` object.

### Adding a file to Ipfs

You can add it to Ipfs with the `add` method:

```ruby
file.add
```

### Retrieve information about the file

The `add` method will return the object and complete some metadata
that are returned by Ipfs.

Those are `size`, `multihash` and `name`:

```ruby
Ipfs::File.new('README.md').add.tap { |file|
  puts "his hash, returned by Ipfs, is '#{file.multihash}'"
  puts "the file name is #{file.name}"
  puts "his size is #{file.size}"
}

# his hash, returned by Ipfs, is 'QmcK5Six9THFatwK5hxugiSM6bhfEdtvirbpEQXhdcuuqg'
# the file name is README.md
# his size is 2275
```

## Clients related information (debugging purposes)

Several information about Ipfs and the HTTP API are available through the client object.

#### The peer id
```ruby
Ipfs::Client.id
```

#### The library version
```ruby
Ipfs::Client.version
```

### Adresses and gateways

```ruby
Ipfs::Client.addresses
```

### The peer public key
```ruby
Ipfs::Client.public_key
```

### Daemon version, build, commit, etc.

```ruby
Ipfs::Client.daemon
```

### The HTTP API's version on which this library is built

```ruby
Ipfs::Client.api_version
```

## DEPRECATED

## [cat command](#cat-command)

```ruby
client.cat('QmPdrgF7dETUkgQxSEmGVHPj3ff9MjjDJXbXL8wu8BDszp').to_s # => "ruby-ipfs-api\n"
```

## [ls command](#ls-command)

```ruby
client.ls('Qmcc7fRg5h1oVuetPgdfZuQ6tzxGappaDKSDHKDu1DnLGs')


# => [
#  {
#    "Name"=>"ruby-ipfs-api",
#    "Hash"=>"QmPdrgF7dETUkgQxSEmGVHPj3ff9MjjDJXbXL8wu8BDszp",
#    "Size"=>22,
#    "Type"=>2
#  }
#]
```