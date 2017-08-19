require_relative './request'
require_relative './api/generic/id'
require_relative './api/generic/version'
require_relative './api/files/cat'
require_relative './api/files/ls'

module Ipfs
  class Client
    def initialize server = {}
      @request = Request.new server
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

    def ls multi_hash
      execute Command::Ls, multi_hash
    end

    private

    def execute command, *args
      command.parse_response @request.call_api command.make_request *args
    end
  end
end
