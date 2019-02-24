require_relative '../../lib/ruby-ipfs-http-client/connection/unreachable'

RSpec.describe Ipfs::Connection::Unreachable do
  let(:connection) { described_class.new }

  it 'is a Connection' do
    expect(connection).to be_a Ipfs::Connection::Base
  end

  it 'has no host' do
    expect(connection.host).to be_nil
  end

  it 'has no port' do
    expect(connection.port).to be_nil
  end

  describe '#up?' do
    it 'can`t reach API' do
      expect { connection.up? }.to raise_error Ipfs::Error::UnreachableDaemon
    end
  end
end