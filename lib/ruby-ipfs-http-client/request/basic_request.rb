require_relative './request'

module Ipfs
  class BasicRequest < Request
    def initialize(path, **arguments)
      super(path, :post)

      @multihash = arguments[:multihash]
    end

    def options
      @multihash \
        ? { params: { arg: @multihash.raw } } \
        : {}
    end
  end
end