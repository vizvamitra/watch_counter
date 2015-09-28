module WatchCounter
  module Storage
    class Memory

      class Database
        
        CLEANUP_INTERVAL = 60 # seconds

        def initialize stale_interval
          @stale_interval = stale_interval
          @records = []
          start_cleanup_task!
        end

        def push(record)
          new_record = record.merge!(timestamp: Time.now)
          @records << new_record
          new_record
        end

        def actual_records
          from = index_for(stale_border_timestamp)
          from.nil? ? [] : @records[from..-1]
        end

        private

          def stale_border_timestamp
            Time.now - @stale_interval
          end

          def index_for(timestamp)
            (0..@records.size-1).bsearch{|i| @records[i][:timestamp] >= timestamp}
          end

          def start_cleanup_task!
            Thread.start do
              while true do
                @records = actual_records
                sleep CLEANUP_INTERVAL
              end
            end
          end
      end

    end
  end
end