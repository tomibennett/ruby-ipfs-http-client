require_relative '../../../lib/api/files/cat'

describe Ipfs::Command::Cat do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/cat'
  end

  describe '.build_request' do
    let(:multi_hash) { double('Ipfs::Multihash') }
    let(:request) { described_class.build_request multi_hash }

    it 'returns a valid request' do
      allow(multi_hash).to receive(:raw) { 'QmRftHo76tGCsxL4UX2tPDoAUUzMKwej3KGdfqoDafwQQd' }

      expect(request[:verb]).to eq :get
      expect(request[:path]).to eq described_class::PATH
      expect(request[:options]).to include params: { arg: multi_hash.raw }
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
