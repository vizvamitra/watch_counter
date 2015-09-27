require_relative '../spec_helper'
require 'watch_counter/option_parser'

describe WatchCounter::OptionParser do

  let(:parser){ described_class.new }

  describe '#parse' do
    context ' when -b or --bind given' do
      let(:args){ [['-b', '--bind'].sample, 'localhost'] }

      it 'sets http_server => bind option' do
        parsed = parser.parse(args)
        expect( parsed[:http_server][:bind] ).to eq args[1]
      end
    end

    context 'when -p or --port given' do
      let(:args){ [['-p', '--port'].sample, '3000'] }

      it 'sets http_server => port option' do
        parsed = parser.parse(args)
        expect( parsed[:http_server][:port] ).to eq args[1]
      end
    end

    context 'when -s or --storage given' do
      let(:args){ [['-s', '--storage'].sample, 'sqlite'] }

      it 'sets storage => adapter option' do
        parsed = parser.parse(args)
        expect( parsed[:storage][:adapter] ).to eq args[1]
      end

      context 'and given storage is unknown' do
        it 'returns nil' do
          parsed = parser.parse([args[0], 'wrong_storage_string'])
          expect( parsed ).to be_nil
        end

        it 'sets error' do
          parsed = parser.parse([args[0], 'wrong_storage_string'])
          expect( parser.error ).to be_a String
        end
      end
    end

    context 'when -t or --stale-interval given' do
      let(:args){ [['-t', '--stale-interval'].sample, '10'] }

      it 'sets storage => stale_interval option' do
        parsed = parser.parse(args)
        expect( parsed[:storage][:stale_interval] ).to eq args[1]
      end
    end

    context 'when -d or --database given' do
      let(:args){ [['-d', '--database'].sample, 'test.db'] }

      it 'sets storage => database_path option' do
        parsed = parser.parse(args)
        expect( parsed[:storage][:database_path] ).to eq args[1]
      end
    end
  end

end