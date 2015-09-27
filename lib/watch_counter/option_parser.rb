require 'optparse'

module WatchCounter
  class OptionParser

    attr_reader :error

    STORAGES = ['sqlite']

    def parse args
      options = {storage: {}, http_server: {}}
      opt_parser = ::OptionParser.new do |opts|
        opts.banner = "Usage: watch_counter [options]"

        opts.separator ""
        opts.separator "Available options:"

        opts.on("-b", "--bind HOSTNAME",
                "Server hostname or IP address",
                "  Default: localhost)") do |hostname|
          options[:http_server][:bind] = hostname
        end

        opts.on("-p", "--port PORT",
                "Server port",
                "  Default: 4567") do |port|
          options[:http_server][:port] = port
        end

        storage_list = STORAGES.join(', ')
        opts.on("-s", "--storage STORAGE", STORAGES,
                "Storage",
                "  Available: #{storage_list}",
                "  Default: sqlite") do |adapter|
          options[:storage][:adapter] = adapter
        end

        opts.on("-t", "--stale-interval SECONDS", 
                "Interval of time to remember watches",
                "  Default: 6") do |interval|
          options[:storage][:stale_interval] = interval
        end

        opts.separator ""
        opts.separator "Storage-specific options:"

        opts.on("-d", "--database PATH", 
                "Location of SQLite database",
                "  For sqlite storage only",
                "  Default: :memory:") do |db_path|
          options[:storage][:database_path] = db_path
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show gem version") do
          puts "Watch Counter #{WatchCounter::VERSION}"
          exit
        end
      end
      opt_parser.parse!(args.dup)
      options
    rescue ::OptionParser::ParseError => e
      @error = e.message
      nil
    end

    def has_errors?
      !@error.nil?
    end

  end
end