require_relative '../lib/file'

RSpec.describe Ipfs::File do
  let(:path) { ::File.join('spec', 'fixtures', 'dune.txt') }

  describe '.initialize' do
    context 'given a file path' do
      it 'can creates an Ipfs file from a filepath if the file exists' do
        expect(described_class.new path: path).to be_a described_class
      end

      it 'raises an error if the path given does not lead to a file' do
        expect { described_class.new path: '' }.to raise_error Errno::ENOENT
      end

      it 'has no metadata associated with the file given by Ipfs' do
        file = described_class.new path: path

        expect(file.name).to be_nil
        expect(file.size).to be_nil
        expect(file.multihash).to be_nil
      end
    end

    context 'given a multihash' do
      context 'when multihash is a string' do
        let(:multihash) { 'QmcUewL8t3B4aW1VTwbLLgxQLi4hMFrb1ASwLsM1uebSs5' }
        let(:file) { described_class.new multihash: multihash }

        it 'can create an Ipfs file if the multihash is valid' do
          expect(file).to be_a described_class
        end

        it 'cannot create the file if the multihash is invalid' do
          expect{
            described_class.new multihash: ''
          }.to raise_error Ipfs::Error::InvalidMultihash
        end

        it 'has the multihash set' do
          expect(file.multihash).to be_a Ipfs::Multihash
        end

        it 'size and name are not set' do
          expect(file.name).to be_nil
          expect(file.size).to be_nil
        end
      end

      context 'when multihash is an object' do
        let(:multihash) {
          Ipfs::Multihash.new('QmcUewL8t3B4aW1VTwbLLgxQLi4hMFrb1ASwLsM1uebSs5')
        }
        let(:file) { described_class.new multihash: multihash}

        it 'can create an Ipfs file' do
          expect(file).to be_a described_class
        end

        it 'has the multihash set' do
          expect(file.multihash).to eq multihash
        end

        it 'size and name are not set' do
          expect(file.name).to be_nil
          expect(file.size).to be_nil
        end
      end

      context 'when multihash is an unexpected object' do
        it 'raises an error' do
          expect {
            described_class.new multihash: 93
          }.to raise_error Ipfs::Error::InvalidMultihash
        end
      end
    end
  end

  describe '#add' do
    context 'when the file was never added to Ipfs' do
      let(:file) { described_class.new path: path }

      before do
        expect(Ipfs::Client)
          .to receive(:execute)
                .with(Ipfs::Command::Add, path)
                .and_call_original
      end

      it 'adds the file to Ipfs' do
        file.add
      end

      it 'has metadata associated with the file given by Ipfs' do
        file.add

        expect(file.name).to eq ::File.basename(path)
        expect(file.size).to be_an Integer
        expect(file.multihash).to be_a Ipfs::Multihash
      end
    end

    context 'the file has already been added to Ipfs' do
      let(:file) { described_class.new path: path }

      before do
        file.add

        expect(Ipfs::Client)
          .to_not receive(:execute)
                    .with(Ipfs::Command::Add, path)
                    .and_call_original
      end

      it 'does not call the client twice' do
        file.add
      end

      it 'has metadata associated with the file given by Ipfs' do
        expect(file.name).to eq ::File.basename(path)
        expect(file.size).to be_an Integer
        expect(file.multihash).to be_a Ipfs::Multihash
      end
    end
  end

  describe '#cat' do
    context 'when the hash is known' do
      let(:multihash) { Ipfs::File.new(path: path).add.multihash }
      let(:file) { Ipfs::File.new(multihash: multihash) }

      # TODO: file.cat fail unexpectedly
      # 'Error: private key already loaded'.
      # Api Code 0
      # Http code 500
      #
      xit 'returns the file`s content' do
        expect(file.cat).to eq ::File.read path
      end
    end

    context 'when the hash is unknown' do
      let(:file) { Ipfs::File.new(path: path) }

      it 'returns a null value' do
        expect(file.cat).to be_nil
      end
    end
  end
end