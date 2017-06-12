require_relative './request'
require_relative './api/generic/id'
require_relative './api/generic/version'
require_relative './api/files/cat'

module Ipfs
  class Client
    def initialize server = {}
      @request = Request.new server
    end

    def execute command, *args
      command.parse_response @request.call_api command.make_request *args
    end

    def id
      execute Command::Id
    end

    def version
      execute Command::Version
    end

    def cat multi_hash
      execute Command::Cat, multi_hash
    end
  end
end
