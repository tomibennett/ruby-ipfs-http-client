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

    def self.encode(byte_array)
      valid_byte_array(byte_array) \
        ? to_number(byte_array) \
        : ''
    end

    def self.valid_byte_array(byte_array)
      !byte_array.empty? && byte_array.find { |value|
        value < 0 || value > 255
      }.nil?
    end

    def self.to_number(byte_array)
      base10_number = byte_array.pack('C*').unpack('H*').first.to_i(16)
      base58_number = ''
      begin
        base58_number << ALPHABET[base10_number % BASE]
        base10_number /= BASE
      end while base10_number > 0

      base58_number.reverse
    end
  end
end