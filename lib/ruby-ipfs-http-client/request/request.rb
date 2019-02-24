module Ipfs
  class Request
    attr_reader :path, :verb

    def initialize(path, verb)
      @path = path
      @verb = verb
    end

    def options
      {}
    end
  end
end