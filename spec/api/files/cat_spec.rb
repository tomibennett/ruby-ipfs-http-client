require_relative '../../../lib/api/files/cat'

describe Ipfs::Command::Cat do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/cat'
  end

  describe '.make_request' do
    let(:hash) { 'QmRftHo76tGCsxL4UX2tPDoAUUzMKwej3KGdfqoDafwQQd QmRftHo76tGCsxL4UX2tPDoAUUzMKwej3KGdfqoDafwQQd' }
    let(:request) { described_class.make_request hash }

    it 'returns a valid request' do
      expect(request[:method]).to eq :get
      expect(request[:path]).to eq described_class::PATH
      expect(request[:params]).to include arg: hash
    end
  end

  describe '.parse_response' do
    let(:response) { double("HTTP::Response") }

    context 'when provided hash leading to a directory' do
      it 'throws an error informing that the dag node was invalid' do
        allow(response).to receive_message_chain(:status, :code) { 500 }
        allow(response).to receive(:body) {
          File.read \
            File.join('spec', 'fixtures', 'api', 'files', 'cat_invalid_dag_node.json')
        }

        expect {
          described_class.parse_response response
        }.to raise_error(Ipfs::Error::InvalidDagNode, "this dag node is a directory")
      end
    end

    context 'when provided hash leading to a content' do
      it 'provides the response as a string' do
        allow(response).to receive_message_chain(:status, :code) { 200 }
        allow(response).to receive(:body) { "A content" }

        expect(described_class.parse_response response).to eq "A content"
      end
    end
  end
end
