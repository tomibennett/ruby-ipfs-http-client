require 'http'
require 'uri'

module Ipfs
  class Client
    BASE_HOST = 'localhost'
    BASE_PORT = 5001
    BASE_PATH = '/api/v0'

    def self.call_api command
      begin
        HTTP.request(command[:method], url(command[:path]))
      rescue HTTP::ConnectionError
        {}
      end
    end

    def self.url command_path
      URI::HTTP.build \
        host: BASE_HOST,
        port: BASE_PORT,
        path: "#{BASE_PATH}#{command_path}"
    end
  end
end
