require_relative './connection'

module Ipfs
  class DefaultConnection < Connection
    def initialize
      @host = 'localhost'
      @port = 5001
    end
  end
end