require 'http'
require 'uri'

require_relative '../lib/http_api'

RSpec.describe Ipfs::HttpApi do
  describe '#initialize' do
    let(:http_api) { described_class.new }

    context 'when instantiated without specific information' do
      let(:http_api) { described_class.new }

      it 'has a default host' do
        expect(http_api.host).to eq described_class::DEFAULT_HOST
      end

      it 'has a default port' do
        expect(http_api.port).to eq described_class::DEFAULT_PORT
      end

      it 'has a default base path' do
        expect(http_api.base_path).to eq described_class::DEFAULT_BASE_PATH
      end
    end

    context 'when a specific api connection is provided' do
      describe 'a specific host' do
        let(:specific_host) { 'a.new.host' }
        let(:http_api) { described_class.new host: specific_host }

        it 'have the specific host' do
          expect(http_api.host).to eq specific_host
        end

        it 'keeps the default configuration for port and base path' do
          expect(http_api.port).to eq described_class::DEFAULT_PORT
          expect(http_api.base_path).to eq described_class::DEFAULT_BASE_PATH
        end
      end

      describe 'a specific port' do
        let(:specific_port) { 7591 }
        let(:http_api) { described_class.new port: specific_port }

        it 'have the specific port' do
          expect(http_api.port).to eq specific_port
        end

        it 'keeps the default configuration for host and base path' do
          expect(http_api.host).to eq described_class::DEFAULT_HOST
          expect(http_api.base_path).to eq described_class::DEFAULT_BASE_PATH
        end
      end

      describe 'a specific base path' do
        let(:specific_base_path) { '/yark' }
        let(:http_api) { described_class.new base_path: specific_base_path }

        it 'have the specific base_path' do
          expect(http_api.base_path).to eq specific_base_path
        end

        it 'keeps the default configuration for host and port' do
          expect(http_api.host).to eq described_class::DEFAULT_HOST
          expect(http_api.port).to eq described_class::DEFAULT_PORT
        end
      end
    end

    it 'creates a persistent connection to the Ipfs HTTP API' do
      expect(http_api.connection).to be_a HTTP::Client
    end

    # context 'when IPFS daemon is started' do
    #   context 'calls the id command' do
    #     it 'to check that the connection is successful' do
    #
    #     end
    #
    #     it 'to complete his informations' do
    #     end
    #   end
    # end
    #
    # context 'when the IPFS daemon is not started' do
    #
    # end
  # end
  end

  describe '#full_path' do
    let(:command_path) { '/id' }
    let(:http_api) { described_class.new }

    it 'returns command path concatenated to the api version also known as base path' do
      expect(http_api.send(:full_path, command_path)).to eq "#{http_api.base_path}/id"
    end
  end

  # describe '#call' do
  #   let(:http_api) { described_class.new }
  #   let(:stub_url) { http_api.send(:url, command.path) }
  #
  #   context 'when IPFS daemon is not started' do
  #     before do
  #       stub_request(:get, stub_url)
  #         .to_raise(HTTP::ConnectionError.new)
  #     end
  #
  #     it 'fails to perform call the Ipfs API' do
  #       expect { http_api.call command }.to raise_error HTTP::ConnectionError
  #     end
  #   end
  #
  #   context 'when IPFS daemon is started' do
  #     before do
  #       stub_request(:get, stub_url)
  #         .to_return(status: 200)
  #     end
  #
  #     it 'calls the Ipfs API' do
  #       expect(http_api.call(command).status).to eq 200
  #     end
  #   end
  # end
end
