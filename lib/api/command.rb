require_relative './generic/id'
require_relative './generic/version'
require_relative './files/cat'
require_relative './files/ls'

require_relative '../request/basic_request'
require_relative '../multihash'

module Ipfs
  module Command
    def self.build_request(path, **arguments)
      keys = arguments.keys

      if keys.include?(:multi_hash)
        BasicRequest.new(path, multi_hash: arguments[:multi_hash])
      else
        BasicRequest.new(path)
      end
    end
  end
end