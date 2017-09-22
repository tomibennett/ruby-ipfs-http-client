require_relative '../../dagstream'
require_relative '../../errors'

module Ipfs
  module Command
    class Cat
      PATH = '/cat'

      def self.build_request(multi_hash)
        {
          method: :get,
          path: PATH,
          params: { arg: multi_hash }
        }
      end

      def self.parse_response(response)
        DagStream.new response
      end
    end
  end
end