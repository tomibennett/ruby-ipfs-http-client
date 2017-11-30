require_relative '../../../lib/api/command'
require_relative '../../../lib/api/generic/id'

describe Ipfs::Command::Id do
  let(:node_id) { File.read File.join('spec', 'fixtures', 'id.json')  }

  it 'has the default path' do
    expect(described_class::PATH).to eq '/id'
  end

  describe '.build_request' do
    let(:request) { described_class.build_request }

    it 'returns a request' do
      expect(request).to be_a_kind_of Ipfs::Request
    end

    it 'has a request where the path is the commands one' do
      expect(request.path).to eq described_class::PATH
    end

    it 'has a request where the verb is GET' do
      expect(request.verb).to eq :get
    end

    it 'has a request without options' do
      expect(request.options).to eq Hash.new
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
