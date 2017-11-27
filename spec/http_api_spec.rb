require 'http'
require 'uri'

require_relative '../lib/http_api'

RSpec.describe Ipfs::HttpApi do
  let(:client) { described_class.new }
  let(:stub_url) { client.send(:url, command[:path]) }
  let(:command) do
    {
      verb: :get,
      path: '/id'
    }
  end

  describe '#initialize' do
    context 'when instantiated without specific information' do
      it 'has a default host' do
        expect(client.host).to eq described_class::DEFAULT_HOST
      end

      it 'has a default port' do
        expect(client.port).to eq described_class::DEFAULT_PORT
      end

      it 'has a default base path' do
        expect(client.base_path).to eq described_class::DEFAULT_BASE_PATH
      end
    end

    context 'when a specific api connection is provided' do
      describe 'a specific host' do
        let(:specific_host) { 'a new host' }
        let(:client) { described_class.new host: specific_host }

        it 'have the specific host' do
          expect(client.host).to eq specific_host
        end

        it 'keeps the default configuration for port and base path' do
          expect(client.port).to eq described_class::DEFAULT_PORT
          expect(client.base_path).to eq described_class::DEFAULT_BASE_PATH
        end
      end

      describe 'a specific port' do
        let(:specific_port) { 7591 }
        let(:client) { described_class.new port: specific_port }

        it 'have the specific port' do
          expect(client.port).to eq specific_port
        end

        it 'keeps the default configuration for host and base path' do
          expect(client.host).to eq described_class::DEFAULT_HOST
          expect(client.base_path).to eq described_class::DEFAULT_BASE_PATH
        end
      end

      describe 'a specific base path' do
        let(:specific_base_path) { '/yark' }
        let(:client) { described_class.new base_path: specific_base_path }

        it 'have the specific base_path' do
          expect(client.base_path).to eq specific_base_path
        end

        it 'keeps the default configuration for host and port' do
          expect(client.host).to eq described_class::DEFAULT_HOST
          expect(client.port).to eq described_class::DEFAULT_PORT
        end
      end
    end
  end

  describe '#url' do
    it 'gives back a valid url' do
      expect(stub_url).to be_a URI
    end

    it 'contains the command path' do
      expect(stub_url.path.split('/').last).to eq command[:path].split('/').last
    end
  end

  describe '#call_api' do
    it 'takes hash as command' do
      expect(client).to respond_to(:call_api).with(1).argument
    end

    context 'when IPFS daemon is not started' do
      before do
        stub_request(:get, stub_url)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'fails to perform call the Ipfs API' do
        expect { client.call_api command }.to raise_error HTTP::ConnectionError
      end
    end

    context 'when IPFS daemon is started' do
      before do
        stub_request(:get, stub_url)
          .to_return(status: 200)
      end

      it 'calls the Ipfs API' do
        expect(client.call_api(command).status).to eq 200
      end
    end
  end
end
