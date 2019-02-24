module Ipfs
  module Command
    class Id
      PATH = '/id'

      def self.build_request
        Command.build_request(PATH)
      end

      def self.parse_response(response)
        JSON.parse response
      end
    end
  end
end