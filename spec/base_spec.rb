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

      context 'when the sequence is a valid base 58 number' do
        let(:number) { 'QmfZw5U6oB54PgrbNv7QF314As1VaA4NUhxCAD92SAdq45' }
        let(:byte_array) {
          [18, 32, 255, 253, 188, 104, 3, 19, 221, 168, 222, 83, 127,
           203, 118, 126, 146, 47, 8, 190, 106, 223, 93, 102, 233, 2,
           220, 192, 238, 155, 35, 161, 11, 130]
        }
        it 'returns the byte collection' do
          expect(described_class.decode number).to eq byte_array
        end
      end
    end
  end
end