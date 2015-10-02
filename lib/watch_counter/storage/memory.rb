require 'watch_counter/storage/memory/database'

module WatchCounter
  module Storage
    class Memory

      DEFAULT_STALE_INTERVAL = 10 # seconds

      attr_reader :options

      def initialize options={}
        @options = {
          stale_interval: options[:stale_interval] || DEFAULT_STALE_INTERVAL,
        }
      end

      def get_watches_for_customer(customer_id)
        videos = Hash.new(0)
        db.actual_records.each do |r|
          videos[r[:video_id]] += 1 if r[:customer_id] == customer_id.to_s
        end
        videos.count
      end

      def get_watches_for_video(video_id)
        customers = Hash.new(0)
        db.actual_records.each do |r|
          customers[r[:customer_id]] += 1 if r[:video_id] == video_id.to_s
        end
        customers.count
      end

      def register_watch(customer_id, video_id)
        raise ArgumentError unless customer_id.is_a?(String) || customer_id.is_a?(Integer)
        raise ArgumentError unless video_id.is_a?(String) || video_id.is_a?(Integer)
        customer_id, video_id = customer_id.to_s, video_id.to_s

        new_record = db.push({customer_id: customer_id, video_id: video_id})
        new_record[:timestamp]
      end

      private

        def db
          @db ||= Database.new(@options[:stale_interval])
        end

    end
  end
end