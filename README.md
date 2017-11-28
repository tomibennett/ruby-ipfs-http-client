[![Build Status](https://travis-ci.org/mahloun/ruby-ipfs-api.svg?branch=master)](https://travis-ci.org/mahloun/ruby-ipfs-api)
[![Coverage Status](https://coveralls.io/repos/github/mahloun/ruby-ipfs-api/badge.svg?branch=master)](https://coveralls.io/github/mahloun/ruby-ipfs-api?branch=master)

# ipfs-api

> A client library for the IPFS HTTP API, implemented in Ruby.

Summary:

1. [Usage](#usage)
   1. [Initializing the client](#initializing-the-client)
   2. [id command](#id-command)
   3. [version command](#version-command)
   4. [cat command](#cat-command)
   5. [ls command](#ls-command)
2. [Currently supported commands](#currently-supported-commands)
3. [Coming soon](#coming-soon)

# [Usage](#usage)

## [Initializing the client](#initializing-the-client)

Make sure the Ipfs `daemon` is running, otherwise the client will
not be able to connect and the operation will result in an error:

So, first:

```bash
$> ipfs daemon
```

Then, you can spawn the client:

```ruby
require 'ipfs_api'

client = Ipfs::Client.new
```

You can also specify non-default `host`, `port` and `base_path` for the API location:

```ruby
client = Ipfs::Client.new host: '192.168.1.42', port: 1337, base_path: '/api/v1'
```

## [id command](#id-command)

```ruby
client.id # Hash {"ID" => ..., "PublicKey" => ..., ...}
```

## [version command](#version-command)

```ruby
client.version # Hash {"Version" => ..., "Commit" => ..., ...}
```

## [cat command](#cat-command)

```ruby
client.cat('QmPdrgF7dETUkgQxSEmGVHPj3ff9MjjDJXbXL8wu8BDszp').to_s # => "ruby-ipfs-api\n"
```

## [ls command](#ls-command)

```ruby
client.ls('Qmcc7fRg5h1oVuetPgdfZuQ6tzxGappaDKSDHKDu1DnLGs')
# => [{"Name"=>"ruby-ipfs-api", "Hash"=>"QmPdrgF7dETUkgQxSEmGVHPj3ff9MjjDJXbXL8wu8BDszp", "Size"=>22, "Type"=>2}]
```

# [Currently supported commands](#currently-supported-commands)

- id
- version
- cat
- ls

# [Coming soon](#coming-soon)
- add
- key
- pubsub
