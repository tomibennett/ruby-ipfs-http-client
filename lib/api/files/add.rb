module Ipfs
  module Command
    class Add
      PATH = '/add'

      def self.build_request(filepath)
        Command.build_request(PATH, filepath: filepath)
      end

      def self.parse_response(response)
        JSON.parse response
      end
    end
  end
end
