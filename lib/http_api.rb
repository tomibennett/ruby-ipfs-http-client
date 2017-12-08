require 'http'
require 'uri'

require_relative './ipfs_api'

require_relative './errors'
require_relative './api/command'
require_relative './api/generic/id'

module Ipfs
  class HttpApi
    attr_reader :host, :port, :base_path, :connection
    attr_reader :version
    attr_reader :id, :addresses, :public_key, :agent_version
    attr_reader :daemon

    DEFAULT_HOST = 'localhost'
    DEFAULT_PORT = 5001
    DEFAULT_BASE_PATH = '/api/v0'

    def initialize(**api_server)
      @host = api_server[:host] || DEFAULT_HOST
      @port = api_server[:port] || DEFAULT_PORT
      @base_path = api_server[:base_path] || DEFAULT_BASE_PATH
      @connection = HTTP.persistent URI::HTTP.build(host: @host, port: @port)

      ObjectSpace.define_finalizer(self, proc { connection.close })

      tap {
        @version = Client::VERSION
        retrieve_ids
        retrieve_daemon_version
      }
    end

    def call(command)
      begin
        @connection.request(
          command.verb,
          full_path(command.path),
          command.options
        )
      rescue HTTP::ConnectionError
        raise Ipfs::Error::UnreachableDaemon, "IPFS is not reachable."
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

    def retrieve_daemon_version
      (Command::Version.parse_response call Command::Version.build_request).tap do |version|
        @daemon = {
          version: version['Version'],
          commit: version['Commit'],
          repo: version['Repo'],
          system: version['System'],
          golang: version['Golang']
        }
      end
    end
  end
end