require_relative '../../../lib/api/generic/id'

describe Ipfs::Command::Id do
  let(:node_id) { File.read File.join('spec', 'fixtures', 'id.json')  }

  it 'has the default path' do
    expect(described_class::PATH).to eq '/id'
  end

  describe '.build_request' do
    let(:request) { described_class.build_request }

    it 'returns a valid request' do
      expect(request[:method]).to eq :post
      expect(request[:path]).to eq described_class::PATH
    end
  end

  describe '.parse_response' do
    let(:response) { described_class.parse_response node_id }

    it 'parse the response' do
      expect(response).to be_a Hash
    end

    it 'has the correct ID' do
      expect(response['ID']).to eq JSON.parse(node_id)['ID']
    end

    it 'has the correct PublicKey' do
      expect(response['PublicKey']).to eq JSON.parse(node_id)['PublicKey']
    end

    it 'has the correct Addresses' do
      expect(response['Addresses'])
        .to contain_exactly *(JSON.parse(node_id)['Addresses'])
    end

    it 'has the correct AgentVersion' do
      expect(response['AgentVersion']).to eq JSON.parse(node_id)['AgentVersion']
    end

    it 'has the correct PublicKey' do
      expect(response['PublicKey']).to eq JSON.parse(node_id)['PublicKey']
    end
  end
end
