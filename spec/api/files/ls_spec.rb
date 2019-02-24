require_relative '../../../lib/ruby-ipfs-http-client/api/command'
require_relative '../../../lib/ruby-ipfs-http-client/api/files/ls'

describe Ipfs::Command::Ls do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/ls'
  end

  describe '.build_request' do
    context 'multihash is valid' do
      let(:multihash) { 'QmYqt8otasXXSrqEw32CwfAK7BFdciW9E9oej52JnVabfW' }
      let(:request) { described_class.build_request multihash }

      it 'returns a request' do
        expect(request).to be_a_kind_of Ipfs::Request
      end

      it 'has a request where the path is the commands one' do
        expect(request.path).to eq described_class::PATH
      end

      it 'has a request where the verb is GET' do
        expect(request.verb).to eq :get
      end

      it 'has a request options containing the multihash' do
        expect(request.options).to eq params: { arg: multihash }
      end
    end

    context 'multihash is invalid' do
      it 'cannot perform the request' do
        expect { described_class.build_request '' }.to raise_error Ipfs::Error::InvalidMultihash
      end
    end
  end

  describe '.parse_response' do
    context 'multihash given point to a directory' do
      let(:api_response) { double('HTTP::Response') }
      let(:parsed_response) { described_class.parse_response api_response }

      before do
        allow(api_response).to receive_message_chain(:status, :code) { 200 }
        allow(api_response).to receive(:body) {
          File.read File.join('spec', 'fixtures', 'api', 'files', 'ls_output.json')
        }
      end

      it 'returns a collection containing links to Ipfs objects' do
        expect(parsed_response).to be_an Array
        expect(parsed_response[0].keys).to eq %w(Name Hash Size Type)
      end
    end
  end
end