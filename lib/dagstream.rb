require_relative './errors'

module Ipfs
  class DagStream
    attr_reader :content

    def initialize response
      if response.status.code == 200
        @content = response
      else
        raise Error::InvalidDagStream.new JSON.parse(response.body)["Message"]
      end
    end

    def to_s
      @content.body.to_s
    end

    alias to_str to_s
  end
end
