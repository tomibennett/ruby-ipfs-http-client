require_relative '../lib/ruby-ipfs-http-client/multihash'

RSpec.describe Ipfs::Multihash do
  let(:invalid_multihash) { '122041dd7b6443542e75701aa98a0c235951a28a0d851b11564d20022ab11d2589a8' }
  let(:valid_multihash) { 'QmYtUc4iTCbbfVSDNKvtQqrfyezPPnFvE33wFmutw9PBBk' }

  context 'the digest is computed using SHA2-256 algorithm' do
    it 'has SHA2-256 function type' do
      expect(described_class.new(valid_multihash).hash_func_type).to eq :sha256
    end

    it 'has a digest length of 32 bytes' do
      expect(described_class.new(valid_multihash).digest_length).to eq 32
    end
  end

  describe '#raw' do
    it 'returns the multihash' do
      expect(described_class.new(valid_multihash).raw).to eq valid_multihash
    end
  end

  describe '#initialize' do
    context 'given a raw representation of a multihash' do
      it 'instantiates a new object' do
        expect(described_class.new(valid_multihash)).to be_a described_class
      end

      it 'throws an error if the given hash is invalid' do
        expect {
          described_class.new invalid_multihash
        }.to raise_error(Ipfs::Error::InvalidMultihash, "The hash func type could not be found")
      end
    end

    context 'multihash is an unexpected object' do
      it 'throws an error if the given hash is invalid' do
        expect { described_class.new 34 }.to raise_error Ipfs::Error::InvalidMultihash
      end
    end
  end
end