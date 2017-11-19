module Ipfs
  class Base58
    ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    BASE = ALPHABET.length

    def self.decode(number)
      valid?(number) \
        ? to_byte_array(to_base_10(number))
        : []
    end

    def self.to_base_10(base58_number)
      base58_number
        .reverse
        .split(//)
        .each_with_index.reduce(0) do |base10_number, (base58_numeral, index)|
        base10_number + ALPHABET.index(base58_numeral) * (BASE**index)
      end
    end

    def self.to_byte_array(base10_number)
      [base10_number.to_s(16)].pack('H*').unpack('C*')
    end

    def self.valid?(number)
      number.match?(/[#{ALPHABET}]+/)
    end
  end
end