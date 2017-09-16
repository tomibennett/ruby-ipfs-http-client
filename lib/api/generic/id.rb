module Ipfs
  module Command
    class Id
      PATH = '/id'

      def self.build_request
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