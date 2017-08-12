require_relative './errors'

module Ipfs
  class DagStream
    attr_reader :content

    def initialize http_response
      if http_response.status.code == 200
        @content = http_response.body
      else
        raise Error::InvalidDagStream.new JSON.parse(http_response.body)["Message"]
      end
    end
  end
end
