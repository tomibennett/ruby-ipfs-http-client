require 'http'
require 'uri'

module Ipfs
  class Request
    attr_reader :host, :port, :base_path

    DEFAULT_HOST = 'localhost'
    DEFAULT_PORT = 5001
    DEFAULT_BASE_PATH = '/api/v0'

    def initialize(**api_server)
      @host = api_server[:host] || DEFAULT_HOST
      @port = api_server[:port] || DEFAULT_PORT
      @base_path = api_server[:base_path] || DEFAULT_BASE_PATH
    end

    def call_api(command)
      HTTP.request(
        command[:verb],
        url(command[:path]),
        params: command[:params]
      )
    end

    private

    def url(command_path)
      URI::HTTP.build(
        host: @host,
        port: @port,
        path: @base_path + command_path
      )
    end
  end
end