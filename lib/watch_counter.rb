require 'sinatra'
require 'singleton'
require 'sqlite3'

require 'watch_counter/app'
require 'watch_counter/config'
require 'watch_counter/http_server'
require 'watch_counter/sqlite_memory_storage'
require 'watch_counter/version'

module WatchCounter

  class << self
    @app, @config = nil, nil
    attr_reader :app
    attr_accessor :config

    def app
      raise NotConfiguredError unless @config
      @app ||= WatchCounter::App.new(@config)
    end
  end

  class NotConfiguredError < StandardError; end

end