require_relative './base'

module Ipfs
  module Connection
    class Default < Base
      def initialize
        @host = 'localhost'
        @port = 5001
      end
    end
  end
end