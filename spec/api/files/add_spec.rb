require_relative '../../../lib/api/command'
require_relative '../../../lib/api/files/add'


describe Ipfs::Command::Add do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/add'
  end

  describe '.build_request' do
    let(:filepath) { './test.txt' }
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

    it 'has a request options containing the filepath' do
      expect(request.options).to eq params: { arg: filepath }
    end
  end

  describe '.parse_response' do
    let(:response) { double('HTTP::Response') }
  end
end