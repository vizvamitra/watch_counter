module WatchCounter
  module Storage
    class Sqlite

      DEFAULT_STALE_INTERVAL = 10 # seconds
      DEFAULT_DATABASE_PATH = ':memory:'

      attr_reader :options

      def initialize options={}
        @options = {
          stale_interval: options[:stale_interval] || DEFAULT_STALE_INTERVAL,
          database_path: options[:database_path] || DEFAULT_DATABASE_PATH
        }
        start_cleanup_task
      end

      def get_watches_for_customer(customer_id)
        from = Time.now.to_i - @options[:stale_interval]
        get_watches_for_customer_query.execute(customer_id, from).next[0]
      end

      def get_watches_for_video(video_id)
        from = Time.now.to_i - @options[:stale_interval]
        get_watches_for_video_query.execute(video_id, from).next[0]
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
            SQLite3::Database.new(@options[:database_path], :type_translation => true).tap do |db|
              db.execute(<<-SQL)
                CREATE TABLE IF NOT EXISTS watches (
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
              remove_old_records_query.execute(Time.now - @options[:stale_interval])
              sleep 60
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
end