require 'http'
require 'uri'

require_relative './errors'
require_relative './api/command'
require_relative './api/generic/id'

require_relative './connection/default'
require_relative './connection/ipfs_config'
require_relative './connection/unreachable'

module Ipfs
  class Client
    DEFAULT_BASE_PATH = '/api/v0'
    CONNECTION_METHODS = [
      Connection::Default,
      Connection::IpfsConfig,
      Connection::Unreachable
    ]

    class << self
      def initialize
        attempt_connection

        retrieve_ids
        retrieve_daemon_version

        ObjectSpace.define_finalizer(self, proc { connection.close })
      end

      def attempt_connection
        find_up = ->(connections) {
          connections.each { |connection|
            co = connection.new

            return co if co.up?
          }
        }

        @@connection = find_up.call(CONNECTION_METHODS).make_persistent
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

    private_class_method :new
  end
end
