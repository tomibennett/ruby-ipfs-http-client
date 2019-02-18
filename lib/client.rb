require 'http'
require 'uri'

require_relative './errors'
require_relative './api/command'
require_relative './api/generic/id'

require_relative './connection/default'
require_relative './connection/ipfs_config'
require_relative './connection/unreachable'

module Ipfs
  # The client is not intended to be manipulated. It is a singleton class used
  # to route commands and their corresponding requests.
  #
  # However, it contains certain, read-only, information that can be useful for
  # debugging purposes.
  class Client
    # @api private
    DEFAULT_BASE_PATH = '/api/v0'
    # @api private
    CONNECTION_METHODS = [
      Connection::Default,
      Connection::IpfsConfig,
      Connection::Unreachable
    ]

    # @api private
    class << self
      def initialize
        attempt_connection

        retrieve_ids
        retrieve_daemon_version

        ObjectSpace.define_finalizer(self, proc { @@connection.close })
      end


      def execute(command, *args)
        command.parse_response call command.build_request *args
      end

      # Various debugging information concerning the Ipfs node itself
      #
      # @example
      #   Ipfs::Client.id
      #   #=> {
      #     peer_id: 'QmVnLbr9Jktjwx...',
      #     addresses: [
      #       "/ip4/127.0.0.1/tcp/4001/ipfs/QmVwxnW4Z8JVMDfo1jeFMNqQor5naiStUPooCdf2Yu23Gi",
      #       "/ip4/192.168.1.16/tcp/4001/ipfs/QmVwxnW4Z8JVMDfo1jeFMNqQor5naiStUPooCdf2Yu23Gi",
      #       "/ip6/::1/tcp/4001/ipfs/QmVwxnW4Z8JVMDfo1jeFMNqQor5naiStUPooCdf2Yu23Gi",
      #       "/ip6/2a01:e34:ef8d:2940:8f7:c616:...5naiStUPooCdf2Yu23Gi",
      #       "/ip6/2a01:e34:ef8d:2940:...5naiStUPooCdf2Yu23Gi",
      #       "/ip4/78.248.210.148/tcp/13684/ipfs/Qm...o1jeFMNqQor5naiStUPooCdf2Yu23Gi"
      #     ],
      #     public_key: "CAASpgIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwgg...AgMBAAE=",
      #     agent_version: "go-ipfs/0.4.13/3b16b74"
      #   }
      #
      # @return [Hash{Symbol => String, Array<String>}]
      def id
        @@id
      end

      def daemon
        @@daemon
      end

      private

      def call(command)
        begin
          @@connection.request(
            command.verb,
            "#{DEFAULT_BASE_PATH}#{command.path}",
            command.options
          )
        rescue HTTP::ConnectionError
          raise Ipfs::Error::UnreachableDaemon, "IPFS is not reachable."
        end
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

      def retrieve_ids
        (execute Command::Id).tap do |ids|
          @@id = {
            peer_id: ids['ID'],
            addresses: ids['Addresses'],
            public_key: ids['PublicKey'],
            agent_version: ids['AgentVersion'],
          }
        end
      end

      def retrieve_daemon_version
        (execute Command::Version).tap do |version|
          @@daemon = {
            version: version['Version'],
            commit: version['Commit'],
            repo: version['Repo'],
            system: version['System'],
            golang: version['Golang'],
            api: DEFAULT_BASE_PATH.split('/')[-1]
          }
        end
      end
    end

    initialize

    private_class_method :new
  end
end
