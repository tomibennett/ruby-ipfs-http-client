require_relative './errors'

module Ipfs

  class Multihash
    attr_reader :hash_func_type, :digest_length, :digest_value

    DEFAULT_LENGTH = 46
    VALID_DIGEST_LENGTH = 'm'
    FUNCTION_TYPE_CODE = {
      sha256: 'Q'
    }

    def initialize(hash)
      @hash_func_type = hash[0]
      @digest_length = hash[1]
      @digest_value = hash[2..-1]

      raise Ipfs::Error::InvalidMultihash, "The hash '#{raw}' is invalid." unless valid?
    end

    def raw
      "#{@hash_func_type}#{@digest_length}#{@digest_value}"
    end

    alias to_s raw

    private

    def valid?
      correct_length? && encoded_digest?(:sha256)
    end

    def correct_length?
      raw.length == DEFAULT_LENGTH
    end

    def encoded_digest?(encoding)
      @hash_func_type == FUNCTION_TYPE_CODE[encoding]
    end
  end
end