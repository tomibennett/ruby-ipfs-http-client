module Ipfs
  module Command
    class Add
      PATH = '/add'

      def self.build_request(filepath)
        Command.build_request(PATH, file_upload: filepath)
      end

      def self.parse_response(response)
      end
    end
  end
end