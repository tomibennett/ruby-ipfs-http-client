require_relative './errors'

module Ipfs
  VALID_LENGTH = 46
  FUNCTION_TYPE_CODE = {
    sha256: 'Q'
  }

  SHA256_FUNCTION_TYPE_CODE = 'Q'

  class Multihash
    def initialize(hash)
      @hash = hash

      raise Ipfs::Error::InvalidMultihash, "The hash '#{@hash}' is invalid." unless valid?
    end

    def raw
      @hash
    end

    alias to_s raw

    private

    def valid?
      correct_length? && encoded_digest?(:sha256)
    end

    def correct_length?
      @hash.length == VALID_LENGTH
    end

    def encoded_digest?(encoding)
      function_type_code == FUNCTION_TYPE_CODE[encoding]
    end

    def function_type_code
      @hash[0]
    end
  end
end