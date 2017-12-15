require_relative '../lib/ipfs_api'

RSpec.describe Ipfs::Client do
  let(:id_command_url) { 'http://localhost:5001/api/v0/id' }

  describe '#call' do
    let(:id_command) { double('Ipfs::Request', verb: :get, path: '/id', options: {}) }

    context 'when IPFS is unreachable' do
      before do
        stub_request(:get, id_command_url)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'fails to perform call the Ipfs API' do
        expect {
          described_class.call id_command
        }.to raise_error Ipfs::Error::UnreachableDaemon
      end
    end

    context 'when IPFS is reachable' do
      it 'can call the Ipfs API' do
        expect { described_class.call id_command }.not_to raise_error
      end
    end
  end

  describe '#connection' do
    it 'is connected to Ipfs' do
      expect(described_class.connection).to be_a HTTP::Client
    end
  end

  describe '#id' do
    it 'returns the id' do
      expect(described_class.id).to be_a String
    end
  end

  describe '#addresses' do
    it 'returns the addresses' do
      expect(described_class.addresses).to match(a_collection_including(String))
        end
  end

  describe '#public_key' do
    it 'returns the public key' do
      expect(described_class.public_key).to be_a String
    end
  end

  describe '#agent_version' do
    it 'returns the agent version' do
      expect(described_class.agent_version).to be_a String
    end
  end

  describe '#version' do
    it 'returns the current library version' do
      expect(described_class.version).to eq Ipfs::VERSION
    end
  end

  describe '#daemon' do
    it 'returns the daemon informations' do
      expect(described_class.daemon[:version]).to be_a String
      expect(described_class.daemon[:commit]).to be_a String
      expect(described_class.daemon[:repo]).to be_a String
      expect(described_class.daemon[:system]).to be_a String
      expect(described_class.daemon[:golang]).to be_a String
    end
  end

  describe '#api_version' do
    it 'returns the version of the Ipfs HTTP api' do
      expect(described_class.api_version).to match(/v\d/)
    end
  end
end
