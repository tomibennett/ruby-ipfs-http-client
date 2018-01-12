require_relative '../lib/ipfs_api'

RSpec.describe Ipfs::Client do
  let(:id_command_url) { 'http://localhost:5001/api/v0/id' }

  describe 'attempting connection to API using different methods' do
    it 'knows two methods to connect to the api' do
      expect(described_class::CONNECTION_METHODS.length).to eq 3
    end

    describe '#attempt_connection' do
      context 'an attempt succeeded' do
        it 'is connected to Ipfs' do
          expect(described_class.send(:attempt_connection)).to_not be_nil
        end
      end

      context 'all attempt have failed' do
        # program terminates
      end
    end
  end

  describe '#call' do
    let(:id_command) { double('Ipfs::Request', verb: :get, path: '/id', options: {}) }

    context 'when IPFS is unreachable' do
      before do
        stub_request(:get, id_command_url)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'fails to perform call the Ipfs API' do
        expect {
          described_class.send(:call, id_command)
        }.to raise_error Ipfs::Error::UnreachableDaemon
      end
    end

    context 'when IPFS is reachable' do
      it 'can call the Ipfs API' do
        expect { described_class.send(:call, id_command) }.not_to raise_error
      end
    end
  end

  describe '#id' do
    let(:id) { described_class.id }

    it 'returns the id' do
      expect(id[:peer_id]).to be_a String
      expect(id[:addresses]).to match a_collection_including(String)
      expect(id[:public_key]).to be_a String
      expect(id[:agent_version]).to be_a String
    end
  end

  describe '#daemon' do
    let(:daemon) { described_class.daemon }

    it 'returns the daemon informations' do
      expect(daemon[:version]).to be_a String
      expect(daemon[:commit]).to be_a String
      expect(daemon[:repo]).to be_a String
      expect(daemon[:system]).to be_a String
      expect(daemon[:golang]).to be_a String
      expect(daemon[:api]).to be_a String
    end
  end
end