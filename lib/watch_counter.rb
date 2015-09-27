require 'sinatra'
require 'sqlite3'
require 'puma'

require 'watch_counter/app'
require 'watch_counter/config'
require 'watch_counter/http_server'
require 'watch_counter/storage_adapter'
require 'watch_counter/version'

module WatchCounter

  class << self
    def config
      @config ||= WatchCounter::Config.new
    end

    def configure options
      @config = WatchCounter::Config.new(options)
    end

    def app
      @app ||= WatchCounter::App.new(config)
    end
  end

end