module Ipfs
  class Base16
    ALPHABET = '0123456789abcdef'

    def self.decode(hexdigits)
      valid?(hexdigits) \
        ? convert_to_byte_array(hexdigits) \
        : []
    end

    def self.convert_to_byte_array(hexdigits)
      convert_to_byte = lambda do |hexdigits|
        hexdigits
          .each_char
          .reduce(0) { |byte, hexdigit| byte * 16 + ALPHABET.index(hexdigit) }
      end

      hexdigits
        .scan(/.{1,2}/)
        .map { |hex_digits_pair| convert_to_byte.(hex_digits_pair) }
    end

    def self.valid?(hexdigits)
      hexdigits.match?(/\A[\d#{ALPHABET}]+\z/i)
    end
  end
end