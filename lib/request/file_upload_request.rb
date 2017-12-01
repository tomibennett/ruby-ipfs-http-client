require_relative './request'

module Ipfs
  class FileUploadRequest < Request
    def initialize(path, **arguments)
      super(path, :post)

      @filepath = arguments[:file_upload]
    end

    def options
      @filepath \
        ? { params: { arg: @filepath } }
        : {}
    end
  end
end