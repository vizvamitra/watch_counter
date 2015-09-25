require_relative '../spec_helper'

describe WatchCounter::App do

  let(:instance){ WatchCounter::App.new }

  describe 'initialize' do
    it 'sets settings' do
      expect(WatchCounter::Settings.get(:storage)).to be_nil
      instance
      expect(WatchCounter::Settings.get(:storage)).to eq WatchCounter::MemoryStorage
    end
  end
  
  describe 'start' do
    let(:server){ double() }

    it 'starts web app' do
      expect(WatchCounter::HttpServer).to receive(:run!)
      instance.start
    end

    it 'starts background workers'
  end
end