require_relative './base'
require_relative './errors'

module Ipfs
  class Multihash
    attr_reader :hash_func_type, :digest_length

    FUNCTIONS = [
      { name: :sha256, type_code: 0x12, digest_length: 0x20 }
    ]

    def initialize(multihash)
      @base58_encoded = multihash
      @bytes_encoded = to_bytes

      @function = find_hash_function(@bytes_encoded[0])

      raise Error::InvalidMultihash, "The hash func type could not be found" if @function.nil?

      @hash_func_type = @function[:name]
      @digest_length = @function[:digest_length]

      raise Error::InvalidMultihash,
            "The hash '#{@base58_encoded}' is invalid." unless correct_length?
    end

    def to_bytes
      [Base58.decode(@base58_encoded).to_s(16)]
        .pack('H*')
        .unpack('C*')
    end

    def raw
      @base58_encoded
    end

    alias to_s raw

    private

    def find_hash_function(func_type_code)
      FUNCTIONS.find { |function| function[:type_code] == func_type_code }
    end

    def correct_length?
      @digest_length == @bytes_encoded[2..-1].length
    end
  end
end