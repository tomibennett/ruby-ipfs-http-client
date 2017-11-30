require_relative '../../dagstream'

module Ipfs
  module Command
    class Cat
      PATH = '/cat'

      def self.build_request(multihash)
        Command.build_request(PATH, multihash: Ipfs::Multihash.new(multihash))
      end

      def self.parse_response(response)
        DagStream.new response
      end
    end
  end
end