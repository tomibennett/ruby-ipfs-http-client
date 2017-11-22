module Ipfs
  module Command
    class Id
      PATH = '/id'

      def self.build_request
        {
          verb: :post,
          path: PATH
        }
      end

      def self.parse_response(response)
        JSON.parse response
      end
    end
  end
end