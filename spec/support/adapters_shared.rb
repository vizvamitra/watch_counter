shared_examples 'storage adapter' do

  describe 'interface' do
    it 'responds to #options method' do
      expect(storage).to respond_to(:options)
    end

    it "responds to #get_watches_for_customer method" do
      expect(storage).to respond_to(:get_watches_for_customer)
    end

    it "responds to #get_watches_for_video method" do
      expect(storage).to respond_to(:get_watches_for_video)
    end

    it "responds to #register_watch method" do
      expect(storage).to respond_to(:register_watch)
    end

    describe '#get_watches_for_customer' do
      context 'when customer is already known' do
        before(:each){ storage.register_watch('known_customer', 0) }

        it 'returns an integer' do
          expect( storage.get_watches_for_customer('known_customer') ).to be_a(Integer)
        end
      end
      
      context 'when customer is unknown' do
        it 'returns an integer' do
          expect( storage.get_watches_for_customer('unknown_customer') ).to be_a(Integer)
        end
      end
    end

    describe '#get_watches_for_video' do
      context 'when video is being watched' do
        before(:each){ storage.register_watch(0, 'known_video') }

        it 'returns an integer' do
          expect( storage.get_watches_for_video('known_video') ).to be_a(Integer)
        end
      end
      
      context 'when video is not being watched' do
        it 'returns an integer' do
          expect( storage.get_watches_for_video('unknown_video') ).to be_a(Integer)
        end
      end
    end

    describe '#register_watch' do
      it 'acceps strings or integers as it\'s arguments' do
        expect{ storage.register_watch('string', 'string') }.not_to raise_error
        expect{ storage.register_watch('string', 1) }.not_to raise_error
        expect{ storage.register_watch(1, 'string') }.not_to raise_error
        expect{ storage.register_watch(1, 1) }.not_to raise_error
      end

      it 'raises ArgumentError if given arguments has wrong type' do
        expect{ storage.register_watch({}, 'video') }.to raise_error(ArgumentError)
        expect{ storage.register_watch('customer', {}) }.to raise_error(ArgumentError)
        expect{ storage.register_watch({}, {}) }.to raise_error(ArgumentError)
      end

      it 'returns Time object' do
        expect( storage.register_watch('customer', 'video') ).to be_a Time
      end
    end
  end


  describe 'behavior' do
    let(:id_sets){ [[0, 0], [0, 1], [0, 2], [0, 0], [1, 0]] }

    around(:each) do |example|
      @freeze_time = Time.now
      Timecop.freeze(@freeze_time, &example)
    end

    it 'stores and retrieves watches count for video' do
      expect( storage.get_watches_for_video(0) ).to eq 0
      expect( storage.get_watches_for_video(1) ).to eq 0
      expect( storage.get_watches_for_video(2) ).to eq 0

      id_sets.each{|cid, vid| storage.register_watch(cid, vid) }

      expect( storage.get_watches_for_video(0) ).to eq 2
      expect( storage.get_watches_for_video(1) ).to eq 1
      expect( storage.get_watches_for_video(2) ).to eq 1
    end

    it 'stores and retrieves watches count for customer' do
      expect(storage.get_watches_for_customer(0)).to eq 0
      expect(storage.get_watches_for_customer(1)).to eq 0

      id_sets.each{|cid, vid| storage.register_watch(cid, vid) }

      expect(storage.get_watches_for_customer(0)).to eq 3
      expect(storage.get_watches_for_customer(1)).to eq 1
    end

    it 'forgets stale watches' do
      id_sets.each{|cid, vid| storage.register_watch(cid, vid) }
      expect(storage.get_watches_for_customer(0)).to eq 3
      expect(storage.get_watches_for_video(0)).to eq 2

      Timecop.travel(@freeze_time + storage.options[:stale_interval])
      expect(storage.get_watches_for_customer(0)).to eq 0
      expect(storage.get_watches_for_video(0)).to eq 0
    end
  end

end
