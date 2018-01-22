require_relative './multihash'
require_relative './api/files/add'
require_relative './api/files/cat'

module Ipfs
  # @attr_reader [String] path The file's path.
  # @attr_reader [Ipfs::Multihash] multihash The file's multihash as returned by Ipfs.
  # @attr_reader [Integer] size The file's size in bytes as returned by Ipfs.
  # @attr_reader [String] name The file's name as returned by Ipfs.
  class File
    attr_reader :path, :multihash, :size, :name

    def initialize(**attributes)
      attributes.each { |name, value|
        instance_variable_set("@#{name}".to_sym, send("init_#{name}", value))
      }

      @added = false
    end

    def add
      tap {
        Ipfs::Client.execute(Command::Add, @path).tap { |response|
          @added = true

          @multihash = init_multihash(response['Hash'])
          @size = response['Size'].to_i
          @name = response['Name']
        } if !@added
      }
    end

    def cat
      begin
        Ipfs::Client.execute(Command::Cat, @multihash).to_s if @multihash
      rescue Ipfs::Error::InvalidDagStream
        ''
      end
    end

    private

    def init_multihash(multihash)
      multihash.is_a?(Multihash) ? multihash : Multihash.new(multihash)
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