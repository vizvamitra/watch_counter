module WatchCounter
  class App
    def initialize
      Settings.set({
        storage: WatchCounter::MemoryStorage
      })
    end

    def start
      HttpServer.run!
    end
  end
end