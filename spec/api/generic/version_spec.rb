require_relative '../../../lib/api/command'
require_relative '../../../lib/api/generic/version'

describe Ipfs::Command::Version do
  let(:daemon_version) { File.read File.join('spec', 'fixtures', 'version.json')  }

  it 'has the default path' do
    expect(described_class::PATH).to eq '/version'
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
    let(:response) { described_class.parse_response daemon_version }

    it 'parse the response from a json formatted data' do
      expect(response).to be_a Hash
    end
  end
end
