require_relative '../lib/dagnode'

RSpec.describe Ipfs::DagNode do
  describe '.initialize' do
    context 'when response from Ipfs\' API is leading to a directory' do
      let(:response) { double("HTTP::Response") }

      it 'throws an error informing that the dag node was invalid' do
        allow(response).to receive_message_chain(:status, :code) { 500 }
        allow(response).to receive(:body) {
          File.read \
                 File.join('spec', 'fixtures', 'api', 'files', 'cat_invalid_dag_node.json')
        }

        expect {
          described_class.new response
        }.to raise_error(Ipfs::Error::InvalidDagNode, "this dag node is a directory")
        end
    end

    context 'when response from Ipfs\' API is leading to a content' do
      before do
        allow(response).to receive_message_chain(:status, :code) { 200 }
        allow(response).to receive(:body) { "A content" }
      end

      let(:response) { double("HTTP::Response") }
      let(:dag_node) { described_class.new response }

      it 'instanciates a dag node' do
        expect(dag_node).to be_a Ipfs::DagNode
      end

      it "contains the Ipfs server's response" do
        expect(dag_node.content).to be_a response.body.class
      end
    end
  end
end
