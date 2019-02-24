require_relative '../../lib/ruby-ipfs-api/request/basic_request'

RSpec.describe Ipfs::BasicRequest do
  let(:id_path) { '/id' }
  let(:multihash) { double("Ipfs::Multihash", raw: 'Qmfootruc') }

  describe '.initialize' do
    it 'needs at least a path to be instantiated' do
      expect(described_class.new id_path).to be_a described_class
    end

    it 'is a request' do
      expect(described_class.new id_path).to be_a_kind_of Ipfs::Request
    end

    it 'can take an optional multihash' do
      expect(described_class.new id_path, multihash: multihash).to be_a described_class
    end
  end

  describe '#path' do
    let(:id_request) { described_class.new id_path }

    it 'gives back the path passed at the instantiation' do
      expect(id_request.path).to eq id_path
    end
  end

  describe '#verb' do
    let(:id_request) { described_class.new id_path }

    it 'gives back the GET HTTP verb' do
      expect(id_request.verb).to eq :get
    end
  end

  describe '#options' do
    context 'request instantiated without multihash' do
      let(:id_request) { described_class.new id_path }

      it 'gives back an empty hash' do
        expect(id_request.options).to eq Hash.new
      end
    end

    context 'request instantiated with a multihash' do
      let(:id_request) { described_class.new id_path, multihash: multihash }

      it 'gives back the multihash wrapped in a format understandable for HTTP library' do
        expect(id_request.options).to eq params: { arg: multihash.raw }
      end
    end
  end
end