require_relative './request'
require_relative './api/generic/id'
require_relative './api/generic/version'
require_relative './api/files/cat'
require_relative './api/files/ls'
require_relative './multihash'

module Ipfs
  class Client
    def initialize(server = {})
      @request = Request.new server
    end

    def id
      execute Command::Id
    end

    def version
      execute Command::Version
    end

    def cat(multi_hash)
      execute Command::Cat, Multihash.new(multi_hash)
    end

    def ls(multi_hash)
      execute Command::Ls, Multihash.new(multi_hash)
    end

    private

    def execute(command, *args)
      command.parse_response @request.call_api command.build_request *args
    end
  end
end
