require_relative '../../dagstream'

module Ipfs
  module Command
    class Cat
      PATH = '/cat'

      def self.build_request(multi_hash)
        Command.build_request(PATH, multi_hash: multi_hash)
      end

      def self.parse_response(response)
        DagStream.new response
      end
    end
  end
end