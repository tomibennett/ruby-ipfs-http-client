require_relative '../lib/http_api'

RSpec.describe Ipfs::HttpApi do
  let(:client_id) { File.read File.join('spec', 'fixtures', 'id.json') }
  let(:daemon_version) { File.read File.join('spec', 'fixtures', 'version.json') }

  let(:http_api) { described_class.new }
  let(:id_command_url) { 'http://localhost:5001/api/v0/id' }

  before do
    stub_request(:get, id_command_url)
      .to_return(status: 200, body: client_id)

    stub_request(:get, 'http://localhost:5001/api/v0/version')
      .to_return(status: 200, body: daemon_version)
  end

  describe '#initialize' do
    # TODO Deprecated behavior that will be removed in next release
    #
    # see https://trello.com/c/z9WZ4bAF
    # and
    # see https://trello.com/c/uoXgKYKh
    #
    # context 'when instantiated without specific information' do
    #   it 'has a default host' do
    #     expect(http_api.host).to eq described_class::DEFAULT_HOST
    #   end
    #
    #   it 'has a default port' do
    #     expect(http_api.port).to eq described_class::DEFAULT_PORT
    #   end
    #
    #   it 'has a default base path' do
    #     expect(http_api.base_path).to eq described_class::DEFAULT_BASE_PATH
    #   end
    # end
    #
    # context 'when a specific api connection is provided' do
    #   describe 'a specific host' do
    #     let(:specific_host) { 'a.new.host' }
    #     let(:http_api) { described_class.new host: specific_host }
    #
    #     it 'have the specific host' do
    #       expect(http_api.host).to eq specific_host
    #     end
    #
    #     it 'keeps the default configuration for port and base path' do
    #       expect(http_api.port).to eq described_class::DEFAULT_PORT
    #       expect(http_api.base_path).to eq described_class::DEFAULT_BASE_PATH
    #     end
    #   end
    #
    #   describe 'a specific port' do
    #     let(:specific_port) { 7591 }
    #     let(:http_api) { described_class.new port: specific_port }
    #
    #     it 'have the specific port' do
    #       expect(http_api.port).to eq specific_port
    #     end
    #
    #     it 'keeps the default configuration for host and base path' do
    #       expect(http_api.host).to eq described_class::DEFAULT_HOST
    #       expect(http_api.base_path).to eq described_class::DEFAULT_BASE_PATH
    #     end
    #   end
    #
    #   describe 'a specific base path' do
    #     let(:specific_base_path) { '/yark' }
    #     let(:http_api) { described_class.new base_path: specific_base_path }
    #
    #     it 'have the specific base_path' do
    #       expect(http_api.base_path).to eq specific_base_path
    #     end
    #
    #     it 'keeps the default configuration for host and port' do
    #       expect(http_api.host).to eq described_class::DEFAULT_HOST
    #       expect(http_api.port).to eq described_class::DEFAULT_PORT
    #     end
    #   end
    # end
    context 'when IPFS is reachable' do
      it 'can retrieve ids' do
        expect(http_api.id).not_to be_nil
        expect(http_api.addresses).not_to be_nil
        expect(http_api.public_key).not_to be_nil
        expect(http_api.agent_version).not_to be_nil
      end
    end

    context 'when IPFS is unreachable' do
      before do
        stub_request(:get, id_command_url)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'cannot instantiate the client' do
        expect{ described_class.new }.to raise_error Ipfs::Error::UnreachableDaemon
      end
    end

    it 'creates a persistent connection to the Ipfs HTTP API' do
      expect(http_api.connection).to be_a HTTP::Client
    end
  end

  describe '#call' do
    let(:id_command) { double('Ipfs::Request', verb: :get, path: '/id', options: {}) }

    context 'when IPFS is unreachable' do
      before do
        stub_request(:get, id_command_url)
          .to_raise(HTTP::ConnectionError.new)
      end

      it 'fails to perform call the Ipfs API' do
        expect {
          http_api.call id_command
        }.to raise_error Ipfs::Error::UnreachableDaemon
      end
    end

    context 'when IPFS is reachable' do
      it 'can call the Ipfs API' do
        expect { http_api.call id_command }.not_to raise_error
      end
    end
  end

  describe '#full_path' do
    let(:command_path) { '/id' }

    it 'returns command path concatenated to the api version also known as base path' do
      expect(http_api.send(:full_path, command_path)).to eq "#{http_api.base_path}#{command_path}"
    end
  end

  describe '#version' do
    it 'returns the current library version' do
      expect(http_api.version).to eq Ipfs::Client::VERSION
    end
  end

  context 'below informations are retrieved by a request made in the constructor' do
    let(:client_id_parsed) { JSON.parse client_id }

    describe '#id' do
      it 'returns the correct id' do
        expect(http_api.id).to eq client_id_parsed['ID']
      end
    end

    describe '#addresses' do
      it 'returns the correct addresses' do
        expect(http_api.addresses)
          .to contain_exactly *(client_id_parsed['Addresses'])
      end
    end

    describe '#public_key' do
      it 'has the correct public key' do
        expect(http_api.public_key).to eq client_id_parsed['PublicKey']
      end
    end

    describe '#agent_version' do
      it 'has the correct agent version' do
        expect(http_api.agent_version).to eq client_id_parsed['AgentVersion']
      end
    end

    describe '#daemon' do
      let(:daemon_version_parsed) { JSON.parse daemon_version }

      it 'retrieves the version' do
        expect(http_api.daemon[:version]).to eq daemon_version_parsed['Version']
      end

      it 'retrieves the commit' do
        expect(http_api.daemon[:commit]).to eq daemon_version_parsed['Commit']
      end

      it 'retrieves the repo' do
        expect(http_api.daemon[:repo]).to eq daemon_version_parsed['Repo']
      end

      it 'retrieves the system' do
        expect(http_api.daemon[:system]).to eq daemon_version_parsed['System']
      end

      it 'retrieves the Golang version' do
        expect(http_api.daemon[:golang]).to eq daemon_version_parsed['Golang']
      end
    end
  end
end
