[![Build Status](https://travis-ci.org/mahloun/ruby-ipfs-api.svg?branch=master)](https://travis-ci.org/mahloun/ruby-ipfs-api)

# ipfs-api

> A client library for the IPFS HTTP API, implemented in Ruby.

Summary:

1. [Usage](#usage)
   1. [Initializing the client](#initializing-the-client)
   2. [The `id` command](#id)
   3. [The `version` command](#version)
   4. [The `cat` command](#cat)
2. [Currently supported commands](#currently-supported-commands)
3. [Coming soon](#coming-soon)

# [Usage](#usage)

## [Initializing the client](#initializing-the-client)

Make sure you Ipfs' `daemonn` is running, otherwise the client will
not able to connect and the operation will result in an error:

So, first:

```bash
$> ipfs deamon
```

Then, you can spawn the client:

```ruby
require 'ipfs-api'

client = Ipfs::Client.new
```

You can also specify non-default `host`, `port` and `base_path` for the API location:

```ruby
client = IPfs::Client.new host: "192.168.1.42", port: 1337, base_path: "/api/v1"
```

## [The `id` command](#id)

```ruby
client.id # Hash {"ID" => ..., "PublicKey" => ..., ...}
```

## [The `version` command](#version)

```ruby
client.version # Hash {"Version" => ..., "Commit" => ..., ...}
```

## [The `cat` command](#cat)

_to write_

# [Currently supported commands](#currently-supported-commands)

- id
- version
- cat

# [Coming soon](#coming-soon)
- ls
- key
- pubsub
