require_relative '../lib/file'

RSpec.describe Ipfs::File do
  let(:file_path) { ::File.join('spec', 'fixtures', 'dune.txt') }
  let(:file) { described_class.new file_path }

  describe '.initialize' do
    context 'given a file path' do
      it 'can initialize from a filepath if the file exists' do
        expect(described_class.new file_path).to be_a described_class
      end

      it 'raises an error if the path given does not lead to a file' do
        expect { described_class.new '' }.to raise_error Errno::ENOENT
      end

      it 'has not metadata associated with the file given by Ipfs' do
        expect(file.name).to be_nil
        expect(file.size).to be_nil
        expect(file.multihash).to be_nil
      end
    end
  end

  describe '#add' do
    context 'the file was never added to Ipfs' do
      before do
        expect(Ipfs::Client)
          .to receive(:execute)
                .with(Ipfs::Command::Add, file_path)
                .and_call_original
      end

      it 'adds the file to Ipfs' do
        file.add
      end

      it 'has metadata associated with the file given by Ipfs' do
        file.add

        expect(file.name).to eq ::File.basename(file_path)
        expect(file.size).to be_an Integer
        expect(file.multihash).to be_a Ipfs::Multihash
      end
    end

    context 'the file has already been added to Ipfs' do
      before do
        file.add

        expect(Ipfs::Client)
          .to_not receive(:execute)
                    .with(Ipfs::Command::Add, file_path)
                    .and_call_original
      end

      it 'does not call the client twice' do
        file.add
      end

      it 'has metadata associated with the file given by Ipfs' do
        expect(file.name).to eq ::File.basename(file_path)
        expect(file.size).to be_an Integer
        expect(file.multihash).to be_a Ipfs::Multihash
      end
    end
  end

  describe '#cat' do
    context 'a file was passed to instantiate the object' do
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