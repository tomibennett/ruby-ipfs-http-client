require_relative '../multihash'

require_relative '../request/basic_request'
require_relative '../request/file_upload_request'

require_relative './generic/id'
require_relative './generic/version'
require_relative './files/cat'
require_relative './files/ls'
require_relative './files/add'

module Ipfs
  module Command
    def self.build_request(path, **arguments)
      keys = arguments.keys

      if keys.include?(:multihash)
        BasicRequest.new(path, multihash: arguments[:multihash])
      elsif keys.include?(:filepath)
        FileUploadRequest.new(path, arguments[:filepath])
      else
        BasicRequest.new(path)
      end
    end
  end
end