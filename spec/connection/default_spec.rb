require_relative '../../lib/ruby-ipfs-api/connection/default'

RSpec.describe Ipfs::Connection::Default do
  let(:location) { { host: 'localhost', port: 5001 } }
  let(:connection) { described_class.new }

  it 'is a Connection' do
    expect(connection).to be_a Ipfs::Connection::Base
  end

  it 'has set a host' do
    expect(connection.host).to eq location[:host]
  end

  it 'has set a port' do
    expect(connection.port).to eq location[:port]
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