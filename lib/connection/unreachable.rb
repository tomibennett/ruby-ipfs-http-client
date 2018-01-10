require_relative './connection'
require_relative '../errors'

module Ipfs
  class Unreachable < Connection
    def up?
      raise Ipfs::Error::UnreachableDaemon, "IPFS is not reachable."
    end
  end
end