require_relative '../lib/dagnode'

RSpec.describe Ipfs::DagNode do
  let(:response) { double("HTTP::Response::Body") }
  let(:dag_node) { described_class.new response }

  it 'is a dag node' do
    expect(dag_node).to be_a Ipfs::DagNode
  end

  it "contains the Ipfs server's response" do
    expect(dag_node.content).to be_a response.class
  end
end
