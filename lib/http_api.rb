require 'http'
require 'uri'

module Ipfs
  class HttpApi
    attr_reader :host, :port, :base_path, :connection

    DEFAULT_HOST = 'localhost'
    DEFAULT_PORT = 5001
    DEFAULT_BASE_PATH = '/api/v0'

    def initialize(**api_server)
      @host = api_server[:host] || DEFAULT_HOST
      @port = api_server[:port] || DEFAULT_PORT
      @base_path = api_server[:base_path] || DEFAULT_BASE_PATH
      @connection = HTTP.persistent URI::HTTP.build(host: @host, port: @port)

      ObjectSpace.define_finalizer(self, proc { self.connection.close })
    end

    def call(command)
      @connection.request(
        command.verb,
        full_path(command.path),
        command.options
      )
    end

    private

    def full_path(command_path)
      "#{@base_path}#{command_path}"
    end
  end
end