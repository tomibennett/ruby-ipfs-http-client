require 'http'
require 'uri'

require_relative './errors'
require_relative './api/command'
require_relative './api/generic/id'

module Ipfs
  class Client
    DEFAULT_HOST = 'localhost'
    DEFAULT_PORT = 5001
    DEFAULT_BASE_PATH = '/api/v0'

    class << self
      def initialize
        @@host = DEFAULT_HOST
        @@port = DEFAULT_PORT
        @@base_path = DEFAULT_BASE_PATH

        @@connection = HTTP.persistent URI::HTTP.build(host: @@host, port: @@port)

        ObjectSpace.define_finalizer(self, proc { connection.close })

        retrieve_ids
        retrieve_daemon_version
      end

      def call(command)
        begin
          @@connection.request(
            command.verb,
            full_path(command.path),
            command.options
          )
        rescue HTTP::ConnectionError
          raise Ipfs::Error::UnreachableDaemon, "IPFS is not reachable."
        end
      end

      def execute(command, *args)
        command.parse_response call command.build_request *args
      end

      def connection
        @@connection
      end

      def id
        @@id
      end

      def addresses
        @@addresses
      end

      def public_key
        @@public_key
      end

      def agent_version
        @@agent_version
      end

      def version
        Ipfs::VERSION
      end

      def daemon
        @@daemon
      end

      def api_version
        @@base_path.split('/')[-1]
      end

      private

      def full_path(command_path)
        "#{@@base_path}#{command_path}"
      end

      def retrieve_ids
        (execute Command::Id).tap do |ids|
          @@id = ids['ID']
          @@addresses = ids['Addresses']
          @@public_key = ids['PublicKey']
          @@agent_version = ids['AgentVersion']
        end
      end

      def retrieve_daemon_version
        (execute Command::Version).tap do |version|
          @@daemon = {
            version: version['Version'],
            commit: version['Commit'],
            repo: version['Repo'],
            system: version['System'],
            golang: version['Golang']
          }
        end
      end
    end

    initialize
  end
end
