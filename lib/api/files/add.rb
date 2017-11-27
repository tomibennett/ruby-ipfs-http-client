require 'http'

module Ipfs
  module Command
    class Add
      PATH = '/add'

      def self.build_request(filepath)
        {
          verb: :post,
          path: PATH,
          options: { form: { arg: HTTP::FormData::File.new(filepath) } }
        }
      end

      def self.parse_response(response)
        JSON.parse response
      end
    end
  end
end