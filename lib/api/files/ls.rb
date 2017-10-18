module Ipfs
  module Command
    class Ls
      PATH = '/ls'

      def self.build_request(multi_hash)
        {
          method: :get,
          path: PATH,
          params: { arg: multi_hash.raw }
        }
      end

      def self.parse_response(response)
        JSON.parse(response.body)['Objects'][0]['Links']
      end
    end
  end
end
