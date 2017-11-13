require_relative '../lib/base'

RSpec.describe Ipfs::Base16 do
  let(:invalid_byte_set) { '1968loifefdsli515688' }
  let(:valid_byte_set) { 'b65e879f65d98a15c5f6d0e9b4a5d' }

  it 'has the hexadecimal alphabet' do
    expect(described_class::ALPHABET).to eq '0123456789abcdef'
  end

  describe '.valid?' do
    context 'when the bytes are invalid' do
      it 'returns false' do
        expect(described_class.valid?(invalid_byte_set)).to eq false
      end
    end

    context 'when the bytes are valid' do
      it 'returns true' do
        expect(described_class.valid?(valid_byte_set)).to eq true
      end
    end
  end

  describe '.decode' do
    context 'when the bytes are invalid' do
      it 'returns an empty array' do
        expect(described_class.decode(invalid_byte_set)).to eq []
      end
    end

    context 'when the bytes are valid' do
      it 'returns the byte array' do
        expect(described_class.decode(valid_byte_set)).to eq [182, 94, 135, 159, 101, 217, 138, 21, 197, 246, 208, 233, 180, 165, 13]
      end
    end
  end
end