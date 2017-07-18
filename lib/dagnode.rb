require_relative './errors'

module Ipfs
  class DagNode
    attr_reader :content

    def initialize http_response
      if http_response.status.code == 200
        @content = http_response.body
      else
        raise Error::InvalidDagNode.new JSON.parse(http_response.body)["Message"]
      end
    end
  end
end
