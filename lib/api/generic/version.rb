module Ipfs
  module Command
    class Version
      PATH = '/version'

      def self.build_request
        {
          verb: :get,
          path: PATH
        }
      end

      def self.parse_response(response)
        JSON.parse response
      end
    end
  end
end
