require_relative './http_api'
require_relative './api/command'
require_relative './multihash'

module Ipfs
  class Client
    def initialize(server = {})
      @http_api = HttpApi.new server
    end

    def id
      execute Command::Id
    end

    def version
      execute Command::Version
    end

    def cat(multihash)
      execute Command::Cat, multihash
    end

    def ls(multihash)
      execute Command::Ls, Multihash.new(multihash)
    end

    private

    def execute(command, *args)
      command.parse_response @http_api.call command.build_request *args
    end
  end
end