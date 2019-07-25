[![Gem Version](https://badge.fury.io/rb/ruby-ipfs-http-client.svg)](https://badge.fury.io/rb/ruby-ipfs-http-client)
[![Build Status](https://travis-ci.org/tbenett/ruby-ipfs-http-client.svg?branch=master)](https://travis-ci.org/tbenett/ruby-ipfs-http-client)

# ruby-ipfs-http-client

> A client library for the IPFS HTTP API, implemented in Ruby.

Summary:

Make sure the Ipfs daemon is running, otherwise
the client will not be able to connect.

You'll get an error `Ipfs::UnreachableDaemon` and the program
execution will stop if daemon is not present.

The client will make a persistent connection to the API.

To access the library from your source file:

```ruby
require 'ipfs'
```

> TODO: use a configuration file and/or environment variables to specify the http http-client url.
Those are hard-coded at the moment :(

## Ipfs::File

This class is intended to manipulate files through Ipfs.

Methods are documented [here](https://www.rubydoc.info/gems/ruby-ipfs-http-client/Ipfs/File)

# Want to Contribute

You can have an overview of the library's design in [CONTRIBUTING.md](./CONTRIBUTING.md).
Yes Let's Contribute !
