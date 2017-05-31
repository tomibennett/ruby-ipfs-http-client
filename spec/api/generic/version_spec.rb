require_relative '../../../lib/api/generic/version'

describe Ipfs::Command::Version do
  it 'has the default path' do
    expect(described_class::PATH).to eq '/version'
  end

  describe '.parse_response' do
    let(:node_version) { File.read File.join('spec', 'fixtures', 'version.json')  }
    let(:response) { described_class.parse_response node_version }

    it 'has the correct version' do
      expect(response["Version"]).to eq JSON.parse(node_version)["Version"]
    end

    it 'has the correct commit' do
      expect(response["Commit"]).to eq JSON.parse(node_version)["Commit"]
    end

    it 'has the correct repo' do
      expect(response["Repo"]).to eq JSON.parse(node_version)["Repo"]
    end

    it 'has the correct system' do
      expect(response["System"]).to eq JSON.parse(node_version)["System"]
    end

    it 'has the correct golang version' do
      expect(response["Golang"]).to eq JSON.parse(node_version)["Golang"]
    end
  end
end
