require_relative '../../lib/connection/base'

RSpec.describe Ipfs::Connection::Base do
  let(:connection) { described_class.new }

  it 'has a default base path' do
    expect(described_class::DEFAULT_BASE_PATH).to eq '/api/v0'
  end

  it 'has no host' do
    expect(connection.host).to be_nil
  end

  it 'has no port' do
    expect(connection.port).to be_nil
  end

  describe '#build_uri' do
    it 'returns a well formatted URI' do
      expect(connection.build_uri).to be_a URI::HTTP
    end
  end
end