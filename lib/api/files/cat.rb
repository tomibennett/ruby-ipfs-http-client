require_relative '../../errors'

module Ipfs
  module Command
    class Cat
      PATH = '/cat'

      def self.make_request multi_hash
        {
          method: :get,
          path: PATH,
          params: { :arg => multi_hash }
        }
      end

      def self.parse_response response
        if response.status.code == 200
          response.body.to_s
        else
          handle_error response.body
        end
      end

      def self.handle_error error
        raise Error::InvalidDagNode.new JSON.parse(error)["Message"]
      end
    end
  end
end
