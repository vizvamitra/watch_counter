module WatchCounter
  class SqliteMemoryStorage
    include Singleton

    STALE_INTERVAL = 6 # seconds

    def initialize
      start_cleanup_task
    end

    def get_watches_for_customer(customer_id)
      get_watches_for_customer_query.execute(customer_id, Time.now.to_i - STALE_INTERVAL).next[0]
    end

    def get_watches_for_video(video_id)
      get_watches_for_video_query.execute(video_id, Time.now.to_i - STALE_INTERVAL).next[0]
    end

    def register_watch(customer_id, video_id)
      raise ArgumentError unless customer_id.is_a?(String) || customer_id.is_a?(Integer)
      raise ArgumentError unless video_id.is_a?(String) || video_id.is_a?(Integer)
      customer_id, video_id = customer_id.to_s, video_id.to_s

      timestamp = Time.now
      register_watch_query.execute(customer_id, video_id, timestamp.to_i)
      timestamp
    end

    private

      def db
        @db ||= begin
          SQLite3::Database.new(":memory:", :type_translation => true).tap do |db|
            db.execute(<<-SQL)
              CREATE TABLE watches (
                customer_id TEXT,
                video_id TEXT,
                timestamp DATETIME DEFAULT CURRENT_DATETIME NOT NULL,
                PRIMARY KEY (customer_id, video_id)
              )
            SQL
          end
        end
      end

      def start_cleanup_task
        Thread.start do
          remove_old_records_query = db.prepare(<<-SQL)
            DELETE
              FROM watches
              WHERE timestamp < datetime(?, 'unixepoch')
          SQL
          while true do
            remove_old_records_query.execute(Time.now - STALE_INTERVAL)
            sleep 0.2
          end
        end
      end

      def get_watches_for_customer_query
        @get_watches_for_customer_query ||= db.prepare(<<-SQL)
          SELECT count(*)
            FROM watches
            WHERE customer_id = ?
            AND timestamp > ?
        SQL
      end

      def get_watches_for_video_query
        @get_watches_for_video_query ||= db.prepare(<<-SQL)
          SELECT count(*)
            FROM watches
            WHERE video_id = ?
            AND timestamp > ?
        SQL
      end

      def register_watch_query
        @register_watch_query ||= db.prepare(<<-SQL)
          INSERT OR REPLACE
            INTO watches (customer_id, video_id, timestamp)
            VALUES (?, ?, ?)
        SQL
      end
  end
end