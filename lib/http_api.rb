require 'http'
require 'uri'

require_relative './errors'
require_relative './api/command'
require_relative './api/generic/id'

module Ipfs
  class HttpApi
    attr_reader :host, :port, :base_path, :connection
    attr_reader :id, :addresses, :public_key, :agent_version

    DEFAULT_HOST = 'localhost'
    DEFAULT_PORT = 5001
    DEFAULT_BASE_PATH = '/api/v0'

    def initialize(**api_server)
      @host = api_server[:host] || DEFAULT_HOST
      @port = api_server[:port] || DEFAULT_PORT
      @base_path = api_server[:base_path] || DEFAULT_BASE_PATH
      @connection = HTTP.persistent URI::HTTP.build(host: @host, port: @port)

      ObjectSpace.define_finalizer(self, proc { connection.close })

      tap { |client| retrieve_ids }
    end

    def call(command)
      begin
        @connection.request(
          command.verb,
          full_path(command.path),
          command.options
        )
      rescue HTTP::ConnectionError
        raise Ipfs::Error::UnreachableDaemon.new("IPFS is not reachable.")
      end
    end

    private

    def full_path(command_path)
      "#{@base_path}#{command_path}"
    end

    def retrieve_ids
      (Command::Id.parse_response call Command::Id.build_request).tap do |ids|
        @id = ids['ID']
        @addresses = ids['Addresses']
        @public_key = ids['PublicKey']
        @agent_version = ids['AgentVersion']
      end
    end
  end
end