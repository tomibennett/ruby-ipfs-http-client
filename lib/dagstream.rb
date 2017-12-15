require_relative './errors'

module Ipfs
  class DagStream
    attr_reader :content

    def initialize(response)
      if response.status.code == 200
        @content = response.body.to_s
      else
        raise Error::InvalidDagStream, JSON.parse(response.body)['Message']
      end
    end

    def to_s
      @content
    end

    alias to_str to_s
  end
end
