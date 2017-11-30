require_relative '../../../lib/api/command'
require_relative '../../../lib/api/files/cat'

describe Ipfs::Command::Cat do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/cat'
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
    let(:response) { double('HTTP::Response') }

    it 'provides the response as a DagStream' do
      allow(response).to receive_message_chain(:status, :code) { 200 }
      allow(response).to receive(:body) { 'A content' }

      expect(described_class.parse_response response).to be_an Ipfs::DagStream
    end
  end
end
