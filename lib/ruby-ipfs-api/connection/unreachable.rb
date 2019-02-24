require_relative './base'
require_relative '../errors'

module Ipfs
  module Connection
    class Unreachable < Base
      def up?
        raise Ipfs::Error::UnreachableDaemon, "IPFS is not reachable."
      end
    end
  end
end