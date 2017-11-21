module Ipfs
  class Base58
    ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    BASE = ALPHABET.length

    def self.decode(number)
      valid?(number) \
        ? to_base10(number)
        : 0
    end

    def self.to_base10(base58_number)
      base58_number
        .reverse
        .split(//)
        .each_with_index
        .reduce(0) do |base10_number, (base58_numeral, index)|
        base10_number + ALPHABET.index(base58_numeral) * (BASE**index)
      end
    end

    def self.valid?(number)
      number.match?(/[#{ALPHABET}]+/)
    end

    def self.encode(base10_number)
      base10_number.is_a?(Integer) \
        ? to_base58(base10_number) \
        : ''
    end

    def self.to_base58(base10_number)
      base58_number = ''

      begin
        base58_number << ALPHABET[base10_number % BASE]
        base10_number /= BASE
      end while base10_number > 0

      base58_number.reverse
    end
  end
end