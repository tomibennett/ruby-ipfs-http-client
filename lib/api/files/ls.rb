module Ipfs
  module Command
    class Ls
      PATH = '/ls'

      def self.build_request(multihash)
        Command.build_request(PATH, multihash: Ipfs::Multihash.new(multihash))
      end

      def self.parse_response(response)
        JSON.parse(response.body)['Objects'][0]['Links']
      end
    end
  end
end
