require_relative './request'

module Ipfs
  class FileUploadRequest < Request
    def initialize(path, filepath)
      super(path, :post)

      @filepath = filepath
    end

    def options
      {
        form: {
          arg: HTTP::FormData::File.new(@filepath)
        }
      }
    end
  end
end