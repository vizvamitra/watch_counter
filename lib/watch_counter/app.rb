module WatchCounter
  class App
    attr_reader :config

    def initialize config
      @config = config
    end

    def start
      HttpServer.run!(bind: @config.bind, port: @config.port)
    end
  end
end