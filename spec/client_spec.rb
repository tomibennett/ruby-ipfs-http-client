require 'http'

require_relative '../lib/client'

RSpec.describe IPFS::Client do
  it 'has a default url' do
    expect(described_class::URL).to eq 'http://localhost:5001/api/v0/'
  end

  describe '.request' do
    it 'takes as parameter an http method and a query string' do
      expect(described_class).to respond_to(:request).with(2).arguments
    end

    context 'when IPFS daemon is not started' do
      before do
        stub_request(:get, described_class::URL)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'fails to perfom call the Ipfs API' do
        expect(described_class.request :get, '').to match({})
      end
    end

    context 'when IPFS daemon is started' do
      before do
        stub_request(:get, described_class::URL)
          .to_return(status: 200)
      end

      it 'performs the request' do
        expect(described_class.request(:get, '').status).to eq 200
      end
    end
  end
end
