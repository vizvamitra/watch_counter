module WatchCounter
  module MemoryStorage
    extend self

    def get_db
      @db
    end

    def get_video_count_for(customer_id)
      db[customer_id].nil? ? 0 : db[customer_id].keys.length
    end

    def get_customer_count_for(video_id)
      5
    end

    def register_watch(customer_id, video_id)
      db[customer_id] ||= {}
      db[customer_id][video_id] = DateTime.now
    end

    private

      def db
        @db ||= {}
      end

  end
end