require_relative './request'
require_relative './api/generic/id'
require_relative './api/generic/version'

module Ipfs
  class Client
    def initialize server = {}
      @request = Request.new server
    end

    def id
      Command::Id.parse_response @request.call_api Command::Id.make_request
    end

    def version
      Command::Version.parse_response @request.call_api Command::Version.make_request
    end
  end
end
