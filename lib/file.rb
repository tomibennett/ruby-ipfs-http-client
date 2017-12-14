require_relative './multihash'
require_relative './api/files/add'

module Ipfs
  class File
    attr_reader :multihash, :size, :name

    def initialize(argument)
      if ::File.file? argument
        @filepath = argument
        @content = ::File.read(@filepath)
      else
        raise Errno::ENOENT, 'no such file or directory'
      end
    end

    def add
      tap {
        Ipfs::Client.execute(Command::Add, @filepath).tap { |response|
          @multihash = Multihash.new response['Hash']
          @size = response['Size'].to_i
          @name = response['Name']
        } unless added?
      }
    end

    def cat
      @content
    end

    private

    def added?
      @multihash != nil
    end
  end
end