require_relative './multihash'
require_relative './api/files/add'

module Ipfs
  class File
    attr_reader :path, :multihash, :size, :name

    def initialize(**attributes)
      attributes.each { |name, value|
        instance_variable_set("@#{name}".to_sym, send("init_#{name}", value))
      }
    end

    def add
      tap {
        Ipfs::Client.execute(Command::Add, @path).tap { |response|
          @multihash = Multihash.new response['Hash']
          @size = response['Size'].to_i
          @name = response['Name']
        } unless added?
      }
    end

    def cat
      @path ? ::File.read(@path) : ''
    end

    private

    def added?
      !@multihash.nil?
    end

    def init_multihash(multihash)
      multihash.is_a?(String) \
        ? Multihash.new(multihash) \
        : multihash
    end

    def init_path(path)
      if ::File.file? path
        path
      else
        raise Errno::ENOENT, 'no such file or directory'
      end
    end
  end
end