require_relative './request'

module Ipfs
  class BasicRequest < Request
    def initialize(path, **arguments)
      super(path, :get)

      @multi_hash = arguments[:multi_hash]
    end

    def options
      @multi_hash \
        ? { params: { arg: @multi_hash.raw } }
        : {}
    end
  end
end