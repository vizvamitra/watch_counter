require_relative '../spec_helper'

describe WatchCounter::Config do

  describe '#initialize' do
    context 'when options are not given' do
      it 'sets options to default values' do
        config = described_class.new
        expect( config.storage ).to eq described_class::DEFAULT[:storage]
        expect( config.http_server ).to eq described_class::DEFAULT[:http_server]
      end
    end

    context 'when options are given' do
      it 'merges given options with default ones' do
        config = described_class.new(storage: {bind: 'hostname'})
        expect( config.storage ).to eq described_class::DEFAULT[:storage].merge({bind: 'hostname'})
      end
    end
  end

end