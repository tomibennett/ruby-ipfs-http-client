require_relative '../../../lib/api/generic/id'

describe IPFS::Client do
  let(:node_id) { File.read File.join('spec', 'fixtures', 'id.json')  }
  let(:uri) { 'http://localhost:5001/api/v0/id' }

  it 'is an IPFS::Client' do
    expect(described_class.new).to be_a IPFS::Client
  end

  describe '#id' do
    context 'when daemon is started' do
      before do
        stub_request(:get, uri)
          .to_return(
            status: 200,
            headers: { 'Content-Type': 'application/json' },
            body: node_id
          )
      end

      let!(:client_id) { described_class.id }

      it 'calls the Ipfs API' do
        expect(WebMock).to have_requested(:get, uri)
      end

      it 'hashes the response' do
        expect(client_id).to be_a Hash
      end

      it 'has the correct ID' do
        expect(client_id["ID"]).to eq JSON.parse(node_id)["ID"]
      end

      it 'has the correct PublicKey' do
        expect(client_id["PublicKey"]).to eq JSON.parse(node_id)["PublicKey"]
      end

      it 'has the correct Addresses' do
        expect(client_id["Addresses"])
          .to contain_exactly *(JSON.parse(node_id)["Addresses"])
      end

      it 'has the correct AgentVersion' do
        expect(client_id["AgentVersion"]).to eq JSON.parse(node_id)["AgentVersion"]
      end

      it 'has the correct PublicKey' do
        expect(client_id["PublicKey"]).to eq JSON.parse(node_id)["PublicKey"]
      end
    end

    context 'when daemon is not started' do
      before do
        stub_request(:get, uri)
          .to_raise(HTTP::ConnectionError.new)
      end

      let!(:client_id) { described_class.id }

      it 'fail to call the Ipfs API' do
        expect(client_id).to include("error")
      end

      it 'has a response containing an error message' do
        expect(client_id['description']).to eq "Daemon is not running"
      end
    end
  end
end
