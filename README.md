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

## Ipfs::Client
The client is not intended to be manipulated at all outside the library. It is a singleton class that is used to route commands and requests inside the library.

However, it contains certain, read-only, informations that can be useful for debugging purposes.

### Ipfs::Client::id
Displays the peer-id.

```ruby
Ipfs::Client::id
# => "QmVnLbr9Jktjwx8AkixVky5Bws8cGsX5hVEJbye2mvC2YY"
```

### Ipfs::Client::version
Displays the version of this library.

```ruby
Ipfs::Client::version
# => "0.5.0"
```

### Ipfs::Client::addresses
Displays addresses and gateways of Ipfs node.

```ruby
Ipfs::Client::addresses
# => [
#      "/ip4/127.0.0.1/tcp/4001/ipfs/QmVwxnW4Z8JVMDfo1jeFMNqQor5naiStUPooCdf2Yu23Gi",
#      "/ip4/192.168.1.16/tcp/4001/ipfs/QmVwxnW4Z8JVMDfo1jeFMNqQor5naiStUPooCdf2Yu23Gi",
#      "/ip6/::1/tcp/4001/ipfs/QmVwxnW4Z8JVMDfo1jeFMNqQor5naiStUPooCdf2Yu23Gi",
#      "/ip6/2a01:e34:ef8d:2940:8f7:c616:...5naiStUPooCdf2Yu23Gi",
#      "/ip6/2a01:e34:ef8d:2940:...5naiStUPooCdf2Yu23Gi",
#      "/ip4/78.248.210.148/tcp/13684/ipfs/Qm...o1jeFMNqQor5naiStUPooCdf2Yu23Gi"
#    ]
```

### Ipfs::Client::public_key
Displays the peer's public key given by the initialize

```ruby
Ipfs::Client::public_key
# => "CAASpgIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwgg...AgMBAAE="
```

### Ipfs::Client::daemon
Displays information about the running daemon.

```ruby
Ipfs::Client::daemon
# => {
#      :version=>"0.4.13",
#      :commit=>"cc01b7f",
#      :repo=>"6",
#      :system=>"amd64/darwin",
#      :golang=>"go1.9.2"
#    }
```

### Ipfs::Client::api_version
Displays the HTTP API version on which this library relies on.

```ruby
Ipfs::Client::api_version
# => "v0"
```