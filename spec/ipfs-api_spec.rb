require_relative '../lib/ipfs-api'

RSpec.describe Ipfs::Client do
  let (:client) { described_class.new }

  describe '#id' do
    it 'respond to id' do
      expect(client).to respond_to(:id).with(0).arguments
    end
  end

  describe '#version' do
    it 'respond to version' do
      expect(client).to respond_to(:version).with(0).arguments
    end
  end
end
