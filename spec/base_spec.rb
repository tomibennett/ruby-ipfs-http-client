require_relative '../lib/base'

RSpec.describe Ipfs::Base58 do
  it 'has the bitcoin alphabet' do
    expect(described_class::ALPHABET).to eq '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  end

  it 'has the base set to 58' do
    expect(described_class::BASE).to eq 58
  end

  describe '.decode' do
    describe 'the base 58 encoded number is passed as sequence of characters' do
      context 'when the sequence is invalid' do
        it 'returns an base 10 number equal to 0' do
          expect(described_class.decode '').to eq 0
          expect(described_class.decode ';)').to eq 0
        end
      end

      context 'when the sequence is a valid base 58 number' do
        it 'returns the corresponding byte collection' do
          expect(described_class.decode 'j').to eq 42
        end
      end
    end
  end

  describe '.encode' do
    describe 'a base 10 number is given' do
      context 'when the number is not an integer' do
        it 'returns an empty sequence of characters if the collection is empty' do
          expect(described_class.encode '').to eq ''
        end
      end

      context 'when the byte array is valid' do
        it 'returns the number encoded in base 58' do
          expect(described_class.encode 42).to eq 'j'
        end
      end
    end
  end
end