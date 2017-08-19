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
  end
end
