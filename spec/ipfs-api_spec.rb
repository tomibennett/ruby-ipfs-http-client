require_relative '../lib/ipfs-api'

RSpec.describe Ipfs do
  describe '.id' do
    it 'respond to id' do
      expect(Ipfs).to respond_to(:id).with(0).arguments
    end
  end

  describe '.version' do
    it 'respond to version' do
      expect(Ipfs).to respond_to(:version).with(0).arguments
    end
  end
end
