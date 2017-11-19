module Ipfs
  class Base58
    ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    BASE = ALPHABET.length

    def self.decode(number)
      valid?(number) \
        ? to_byte_array(number)
        : []
    end

    def self.valid?(number)
      number.match?(/[#{ALPHABET}]+/)
    end
  end
end