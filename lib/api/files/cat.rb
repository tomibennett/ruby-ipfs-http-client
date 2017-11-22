require_relative '../../dagstream'
require_relative '../../errors'

module Ipfs
  module Command
    class Cat
      PATH = '/cat'

      def self.build_request(multi_hash)
        {
          verb: :get,
          path: PATH,
          options: { params: { arg: multi_hash.raw } }
        }
      end

      def self.parse_response(response)
        DagStream.new response
      end
    end
  end
end