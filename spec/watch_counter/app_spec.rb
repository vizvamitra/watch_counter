require_relative '../spec_helper'

describe WatchCounter::App do

  let(:config){ WatchCounter::Config.new }
  let(:app){ described_class.new(config) }

  describe 'initialize' do
    it 'stores config' do
      expect(app.config).to eq config
    end
  end

  describe '#storage' do
    it 'returns instance of storage' do
      expect(app.storage).to be_instance_of(WatchCounter::StorageAdapter::Sqlite)
    end
  end
  
  describe '#start' do
    it 'starts web app' do
      expect(WatchCounter::HttpServer).to receive(:run!)
      app.start
    end
  end
end