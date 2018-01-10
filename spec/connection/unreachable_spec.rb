require_relative '../../lib/connection/unreachable'

RSpec.describe Ipfs::Unreachable do
  let(:connection) { described_class.new }

  it 'is a connection' do
    expect(connection).to be_a Ipfs::Connection
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