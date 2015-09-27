module WatchCounter
  class App
    attr_reader :config

    def initialize config
      @config = config
    end

    def storage
      @storage ||= begin
        options = @config.storage
        adapter_string = options.delete(:adapter)
        adapter_classname = adapter_string.split('_').map!(&:capitalize).join
        adapter_class = WatchCounter::StorageAdapter.const_get(adapter_classname)
        adapter_class.new(options)
      end
    end

    def start
      HttpServer.run!(@config.http_server)
    end
  end
end