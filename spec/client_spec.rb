require 'http'
require 'uri'

require_relative '../lib/client'

RSpec.describe Ipfs::Client do
  let(:command) do
    {
      method: :get,
      path: '/id'
    }
  end
  let(:stub_url) { Ipfs::Client.url command[:path] }

  it 'has a base host' do
    expect(described_class::BASE_HOST).to eq 'localhost'
  end

  it 'has a base path' do
    expect(described_class::BASE_PATH).to eq '/api/v0'
  end

  it 'has a base port' do
    expect(described_class::BASE_PORT).to eq 5001
  end

  describe '.url' do
    it 'gives back a valid url' do
      expect(stub_url).to be_a URI
    end

    it 'contains the command path' do
      expect(stub_url.path.split('/').last).to eq command[:path].split('/').last
    end
  end

  describe '.call_api' do
    it 'takes hash as command' do
      expect(described_class).to respond_to(:call_api).with(1).argument
    end

    context 'when IPFS daemon is not started' do
      before do
        stub_request(:get, stub_url)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'fails to perfom call the Ipfs API' do
        expect(described_class.call_api command).to match '{}'
      end
    end

    context 'when IPFS daemon is started' do
      before do
        stub_request(:get, stub_url)
          .to_return(status: 200)
      end

      it 'calls the Ipfs API' do
        expect(described_class.call_api(command).status).to eq 200
      end
    end
  end
end
