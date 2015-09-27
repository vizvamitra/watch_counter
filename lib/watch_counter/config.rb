module WatchCounter
  class Config < OpenStruct

    def bind
      super || 'localhost'
    end

    def port
      super || 4567
    end

    def storage
      super || WatchCounter::SqliteMemoryStorage
    end

  end
end