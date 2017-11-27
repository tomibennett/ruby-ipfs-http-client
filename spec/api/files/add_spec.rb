require_relative '../../../lib/api/files/add'
require 'http'

describe Ipfs::Command::Add do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/add'
  end

  describe '.build_request' do
    let(:file) { double('HTTP::FormData::File') }
    let(:request) { described_class.build_request file }

    it 'returns a valid request' do
      expect(request[:verb]).to eq :post
      expect(request[:path]).to eq described_class::PATH
      expect(request[:options]).to include form: { arg: file }
    end
  end

  describe '.parse_response' do
    let(:response) { double('HTTP::Response') }
  end
end