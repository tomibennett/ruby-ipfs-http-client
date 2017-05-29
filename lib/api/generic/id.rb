require_relative '../../client'

module Ipfs
  module Command
    class Id
      PATH = '/id'

      def self.make_request
        parse_response Client.call_api method: :get, path: PATH
      end

      def self.parse_response response
        JSON.parse response
      end
    end
  end
end
