require_relative '../../lib/request/file_upload_request'

RSpec.describe Ipfs::FileUploadRequest do
  let(:add_path) { '/add' }
  let(:filepath) { 'path/to/file' }

  describe '.initialize' do

    it 'needs a command path and a file path to be instantiated' do
      expect(described_class.new add_path, filepath).to be_a described_class
    end

    it 'is a request' do
      expect(described_class.new add_path, filepath).to be_a_kind_of Ipfs::Request
    end
  end

  describe '#path' do
    let(:add_request) { described_class.new add_path, filepath }

    it 'gives back the path passed at the instantiation' do
      expect(add_request.path).to eq add_path
    end
  end

  describe '#verb' do
    let(:add_request) { described_class.new add_path, filepath }

    it 'gives back the POST HTTP verb' do
      expect(add_request.verb).to eq :post
    end
  end

  describe '#options' do
    let(:add_request) { described_class.new add_path, file_upload: filepath }
    let(:request_options) { add_request.options }

    it 'gives back a hash containing the file prepared for an HTTP upload' do
      expect(request_options).to match form: {
        arg: an_instance_of(HTTP::FormData::File)
      }
    end
  end
end