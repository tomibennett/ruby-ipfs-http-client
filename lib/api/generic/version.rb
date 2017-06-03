require_relative '../../client'

module Ipfs
  module Command
    class Version
      PATH = '/version'

      def self.make_request
        {
          method: :get,
          path: PATH
        }
      end

      def self.parse_response response
        JSON.parse response
      end
    end
  end
end
