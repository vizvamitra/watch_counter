require 'spec_helper'

describe WatchCounter do
  before(:each) do
    WatchCounter.instance_variable_set(:@config, nil)
    WatchCounter.instance_variable_set(:@app, nil)
  end

  it 'has a version number' do
    expect(WatchCounter::VERSION).not_to be nil
  end

  describe '#config' do
    context 'if config not yet initialized' do
      it 'returns WatchCounter::Config object with default settings' do
        config = double()
        allow(WatchCounter::Config).to receive(:new).and_return(config)
        expect(WatchCounter.config).to eq config
      end
    end

    context 'if config is already initialized' do
      it 'returns previously initialized WatchCounter::Config object' do
        config = double()
        WatchCounter.instance_variable_set(:@config, config)
        expect(WatchCounter.config).to eq config
      end
    end
  end

  describe '#configure' do
    it 'replaces old config with a new one with given options' do
      options = {storage: {stale_interval: 15}}
      WatchCounter.configure(options)
      expect( WatchCounter.config.storage[:stale_interval] ).to eq 15
    end
  end

  describe '#app' do
    context 'if app not yet initialized' do
      it 'initializes and returns WatchCounter::App object with current config' do
        app = double()
        expect(WatchCounter::App).to receive(:new).with(WatchCounter.config).and_return(app)
        expect(WatchCounter.app).to eq app
      end
    end

    context 'if app is already initialized' do
      it 'returns previously initialized WatchCounter::App object' do
        app = double()
        WatchCounter.instance_variable_set(:@app, app)
        expect(WatchCounter.app).to eq app
      end
    end
  end
end
