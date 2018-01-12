require_relative '../../lib/connection/ipfs_config'

RSpec.describe Ipfs::Connection::IpfsConfig do
  let(:location) { { host: '127.0.0.1', port: 5001 } }
  let(:connection) { described_class.new }

  before do
    allow(::File).to receive(:read)
      .with(described_class::CONFIG_FILEPATH)
      .and_return(::File.read ::File.join('spec', 'fixtures', 'ipfs', 'config'))
  end

  it 'is a Connection' do
    expect(connection).to be_a Ipfs::Connection::Base
  end

  it 'knows the Ipfs configuration file path' do
    expect(described_class::CONFIG_FILEPATH).to eq "#{ENV['HOME']}/.ipfs/config"
  end

  describe '#parse_config' do
    it 'retrieves API location from the configuration file' do
      expect(connection.send(:parse_config)).to match location
    end
  end

  describe '#up?' do
    context 'the connection fails' do
      before do
        stub_request(:get, "http://#{location[:host]}:#{location[:port]}/api/v0/id")
          .to_raise HTTP::ConnectionError
      end

      it 'returns false' do
        expect(connection.up?).to eq false
      end
    end

    context 'the connection succeed' do
      before do
        stub_request(:get, "http://#{location[:host]}:#{location[:port]}/api/v0/id")
      end

      it 'returns true' do
        expect(connection.up?).to eq true
      end
    end
  end

  describe '#make_persistent' do
    it 'makes a persistent connection' do
      expect(connection.make_persistent).to be_a HTTP::Client
    end
  end
end