require_relative '../../../lib/api/files/ls'

describe Ipfs::Command::Ls do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/ls'
  end

  describe '.build_request' do
    let(:multi_hash) { double('Ipfs::Multihash') }
    let(:request) { described_class.build_request multi_hash }

    it 'returns a valid request' do
      allow(multi_hash).to receive(:raw) { 'QmRftHo76tGCsxL4UX2tPDoAUUzMKwej3KGdfqoDafwQQd' }

      expect(request[:method]).to eq :get
      expect(request[:path]).to eq described_class::PATH
      expect(request[:params]).to include arg: multi_hash.raw
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
