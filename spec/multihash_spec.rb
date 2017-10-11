require_relative '../lib/multihash'

RSpec.describe Ipfs::Multihash do
  let(:invalid_multihash) { '122041dd7b6443542e75701aa98a0c235951a28a0d851b11564d20022ab11d2589a8' }
  let(:valid_multihash) { 'QmYtUc4iTCbbfVSDNKvtQqrfyezPPnFvE33wFmutw9PBBk' }

  describe '#initialize' do
    context 'given a raw representation of a multihash' do
      it 'instantiates a new object' do
        expect(described_class.new(valid_multihash)).to be_a described_class
      end

      it 'throws an error if the given hash is invalid' do
        expect {
          described_class.new invalid_multihash
        }.to raise_error(Ipfs::Error::InvalidMultihash, "The hash '#{invalid_multihash}' is invalid.")
      end
    end
  end
end