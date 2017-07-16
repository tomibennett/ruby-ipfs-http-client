require 'http'

module Ipfs
  class DagNode
    attr_reader :content

    def initialize content
      @content = content
    end
  end
end
