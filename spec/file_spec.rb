require_relative '../lib/file'

RSpec.describe Ipfs::File do
  let(:file_path) { ::File.join('spec', 'fixtures', 'dune.txt') }

  describe '.initialize' do
    context 'given a file path' do
      it 'can initialize from a filepath if the file exists' do
        expect(described_class.new file_path).to be_a described_class
      end

      it 'raises an error if the path given does not lead to a file' do
        expect { described_class.new '' }.to raise_error Errno::ENOENT
      end
    end
  end

  describe '#cat' do
    context 'a file was passed to instantiate the object' do
      let(:file) { described_class.new file_path }

      it 'returns the content of the file' do
        expect(file.cat).to eq ::File.read file_path
      end

      it 'does not call the client' do
        expect(Ipfs::Client).to_not receive(:execute)

        file.cat
      end
    end
  end
end