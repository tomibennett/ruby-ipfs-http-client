require_relative '../lib/ipfs-api'

RSpec.describe Ipfs::Client do
  let (:client) { described_class.new }

  describe 'commands' do
    let (:commands) { Ipfs::Command::constants }

    it 'has id command loaded' do expect(commands).to include :Id end

    it 'has version command loaded' do expect(commands).to include :Version end

    it 'has cat command loaded' do expect(commands).to include :Cat end
  end

  it 'responds to id' do
    expect(client).to respond_to(:id).with(0).arguments
  end

  it 'responds to version' do
    expect(client).to respond_to(:version).with(0).arguments
  end

  it 'responds to cat' do
    expect(client).to respond_to(:cat).with(1).argument
  end
end
