require 'http'
require 'uri'

require_relative './errors'
require_relative './api/command'
require_relative './api/generic/id'

module Ipfs
  class Client
    IPFS_CONFIG_FILEPATH = "#{ENV['HOME']}/.ipfs/config"
    DEFAULT_SERVER = { host: 'localhost', port: 5001 }
    CONNECTION_METHODS = [
      ->() { DEFAULT_SERVER },
      ->() { parse_config_file },
      ->() { raise Ipfs::Error::UnreachableDaemon, "IPFS is not reachable." }
    ]

    DEFAULT_BASE_PATH = '/api/v0'

    class << self
      def initialize
        attempt_connection

        retrieve_ids
        retrieve_daemon_version

        ObjectSpace.define_finalizer(self, proc { connection.close })
      end

      def connection_up?(connection)
        begin
          HTTP.get(
            "http://#{connection[:host]}:#{connection[:port]}#{DEFAULT_BASE_PATH}/id"
          )
          true
        rescue HTTP::ConnectionError
          false
        end
      end

      def attempt_connection
        CONNECTION_METHODS
          .find { |connection| connection_up? connection.call }
          .tap { |connection| @@connection = HTTP.persistent URI::HTTP.build(connection.call) }
      end

      def execute(command, *args)
        command.parse_response call command.build_request *args
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
        DEFAULT_BASE_PATH.split('/')[-1]
      end

      private

      def full_path(command_path)
        "#{DEFAULT_BASE_PATH}#{command_path}"
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

      def parse_config_file
        %r{.*API.*/ip4/(.*)/tcp/(\d+)}.match(::File.read IPFS_CONFIG_FILEPATH) do |match_data|
          {
            host: match_data[1],
            port: match_data[2].to_i
          }
        end
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
