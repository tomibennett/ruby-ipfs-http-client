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
execution will stop if daemon is not present.

The client will make a persistent connection to the API.

To access the library from your source file:

```ruby
require 'ipfs_api'
```

> TODO: use a configuration file and/or environment variables to specify the http api url. 
Those are hard-coded at the moment :(

## Ipfs::File

This class is intended to manipulate files through Ipfs.

### Ipfs::File::new

You can create a `Ipfs::File` object in multiple ways.

#### From a path

```ruby
Ipfs::File.new(path: 'path/to/file')
#=> #<Ipfs::File:0x00007fabdd199de0 @path="path/to/file", @added=false>
```

#### From a multihash

```ruby
Ipfs::File.new(multihash: 'QmVfpW2rKzzahcxt5LfYyNnnKvo1L7XyRF8Ykmhttcyztv')
#=> #<Ipfs::File:0x00007fabdab57628 @added=false, @multihash=#<Ipfs::Multihash:0x00007fabdab57510 ....>>
```

### Ipfs::File#add

This method allows to add a file to Ipfs.

The main object is returned allowing for chainable actions.

Once the file is added, its multihash is generated and accessible from the object.

```ruby
Ipfs::File.new(path: 'path/to/file')
#=> #<Ipfs::File:0x00007fabdd199de0 @path="path/to/file", @added=false>

Ipfs::File.new(path: 'path/to/file').add
#=> #<Ipfs::File:0x00007fabdd199de0 @path="path/to/file", @added=true, @multihash=...>
```

### Ipfs::File#multihash

Allows to retrieve an Ipfs generated multihash's file.

**If the `Ipfs::File` is created using a path, it needs to be added to Ipfs first.**

```ruby
Ipfs::File.new(path: 'path/to/file').multihash
#=> nil
```

```ruby
Ipfs::File.new(path: 'path/to/file').add.multihash
#=> #<Ipfs::Multihash:0x00007fabdda2d420 ...>

Ipfs::File.new(path: 'path/to/file').add.multihash.raw
#=> "Qmcw6nstA5oANHbX3fxZaWUkhyQBQwUC3f5HPFpxR1SsLd"

Ipfs::File.new(multihash: 'QmScu...J3T').multihash.raw
# => "QmScu...J3T"
```

### Ipfs::File#cat

Allows to retrieve the content of a file from its multihash using Ipfs.

**The multihash must be known to the object, otherwise a null value will be returned.**

```ruby
Ipfs::File.new(path: 'path/to/file').cat
#=> nil
```

```ruby
Ipfs::File.new(multihash: 'QmScu...J3T').cat
#=> "File content..."

Ipfs::File.new(path: 'path/to/file').add.cat
#=> "File content..."
```

### Ipfs::File#name

Allows to retrieve a file name.

**The file must be added to Ipfs first**

```ruby
Ipfs::File.new(path: 'path/to/file').add.name
# => "file"
```

### Ipfs::File#size

Allows to retrieve a file size in bytes.

**The file must be added to Ipfs first**

```ruby
Ipfs::File.new(path: 'path/to/file').add.size
# => 12345
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
Displays the peer's public key.

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