require_relative '../../../lib/api/command'
require_relative '../../../lib/api/files/add'

describe Ipfs::Command::Add do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/add'
  end

  describe '.build_request' do
    let(:filepath) { File.join('spec', 'fixtures', 'api', 'files', 'sample') }
    let(:request) { described_class.build_request filepath }

    it 'returns a request' do
      expect(request).to be_a_kind_of Ipfs::Request
    end

    it 'has a request where the path is the commands one' do
      expect(request.path).to eq described_class::PATH
    end

    it 'has a request where the verb is POST' do
      expect(request.verb).to eq :post
    end

    it 'has a request options containing the FormData object' do
      expect(request.options).to match form: {
        arg: an_instance_of(HTTP::FormData::File)
      }
    end
  end

  describe '.parse_response' do
    let(:add_response) {
      File.read File.join('spec', 'fixtures', 'api', 'files', 'add_response.json')
    }
    let(:response) { described_class.parse_response add_response }

    it 'has the correct file name' do
      expect(response['Name']).to eq JSON.parse(add_response)['Name']
    end

    it 'has the correct multihash' do
      expect(response['Hash']).to eq JSON.parse(add_response)['Hash']
    end

    it 'has the correct size' do
      expect(response['Size']).to eq JSON.parse(add_response)['Size']
    end
  end
end