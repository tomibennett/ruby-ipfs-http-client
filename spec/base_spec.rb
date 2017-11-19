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
      context 'when the sequence is empty' do
        it 'returns an empty byte collection when the sequence is empty' do
          expect(described_class.decode '').to eq []
        end
      end

      context 'when the sequence contains number that are not in the alphabet' do
        it 'returns an empty byte collection' do
          expect(described_class.decode ';)').to eq []
        end
      end
    end
  end
end