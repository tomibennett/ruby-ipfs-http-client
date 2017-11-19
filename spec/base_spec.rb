require_relative '../lib/base'

RSpec.describe Ipfs::Base58 do
  it 'has the bitcoin alphabet' do
    expect(described_class::ALPHABET).to eq '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  end

  it 'has the base set to 58' do
    expect(described_class::BASE).to eq 58
  end
end