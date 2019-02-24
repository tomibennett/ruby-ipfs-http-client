require_relative '../lib/ruby-ipfs-api/dagstream'

RSpec.describe Ipfs::DagStream do
  describe '.initialize' do
    context 'when response from Ipfs API is leading to a directory' do
      let(:response) { double('HTTP::Response') }

      it 'throws an error informing that the dag node was invalid' do
        allow(response).to receive_message_chain(:status, :code) { 500 }
        allow(response).to receive(:body) {
          File.read \
                 File.join('spec', 'fixtures', 'api', 'files', 'cat_invalid_dag_stream.json')
        }

        expect {
          described_class.new response
        }.to raise_error(Ipfs::Error::InvalidDagStream, 'this dag node is a directory')
        end
    end

    context 'when response from Ipfs API is leading to a content' do
      before do
        allow(response).to receive_message_chain(:status, :code) { 200 }
        allow(response).to receive(:body) { 'A content' }
      end

      let(:response) { double('HTTP::Response') }
      let(:dag_stream) { described_class.new response }

      it 'instantiates a dag stream' do
        expect(dag_stream).to be_a Ipfs::DagStream
      end

      describe '#to_s' do
        it 'returns the content' do
          expect(dag_stream.to_s).to eq 'A content'
        end
      end

      describe '#to_str' do
        it 'returns the content' do
          expect(dag_stream.to_str).to eq 'A content'
        end
      end
    end
  end
end
