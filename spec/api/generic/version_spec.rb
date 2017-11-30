require_relative '../../../lib/api/command'
require_relative '../../../lib/api/generic/version'

describe Ipfs::Command::Version do
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
    let(:node_version) { File.read File.join('spec', 'fixtures', 'version.json')  }
    let(:response) { described_class.parse_response node_version }

    it 'has the correct version' do
      expect(response['Version']).to eq JSON.parse(node_version)['Version']
    end

    it 'has the correct commit' do
      expect(response['Commit']).to eq JSON.parse(node_version)['Commit']
    end

    it 'has the correct repo' do
      expect(response['Repo']).to eq JSON.parse(node_version)['Repo']
    end

    it 'has the correct system' do
      expect(response['System']).to eq JSON.parse(node_version)['System']
    end

    it 'has the correct Golang version' do
      expect(response['Golang']).to eq JSON.parse(node_version)['Golang']
    end
  end
end
