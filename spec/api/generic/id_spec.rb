require_relative '../../../lib/ruby-ipfs-http-client/api/command'
require_relative '../../../lib/ruby-ipfs-http-client/api/generic/id'

describe Ipfs::Command::Id do
  let(:client_id) { File.read File.join('spec', 'fixtures', 'id.json')  }

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
    let(:response) { described_class.parse_response client_id }

    it 'parse the response from a json formatted data' do
      expect(response).to be_a Hash
    end
  end
end
