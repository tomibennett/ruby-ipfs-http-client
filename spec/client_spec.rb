require_relative '../lib/client'

RSpec.describe Ipfs::Client do
  let(:client) { described_class.new }

  describe 'commands' do
    let(:commands) { Ipfs::Command::constants }

    it 'has id command loaded' do expect(commands).to include :Id end

    it 'has version command loaded' do expect(commands).to include :Version end

    it 'has cat command loaded' do expect(commands).to include :Cat end

    it 'has ls command loaded' do expect(commands).to include :Ls end
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

  it 'responds to ls' do
    expect(client).to respond_to(:ls).with(1).argument
  end
end
