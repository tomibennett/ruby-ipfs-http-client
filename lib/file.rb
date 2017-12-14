module Ipfs
  class File
    def initialize(argument)
      if ::File.file? argument
        @content = ::File.read(argument)
      else
        raise Errno::ENOENT, 'no such file or directory'
      end
    end

    def cat
      @content
    end
  end
end