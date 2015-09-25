module WatchCounter
  module Settings extend self

    def get name
      settings[name]
    end

    def set settings_hash
      @settings = settings_hash
    end

    private

      def settings
        @settings ||= {}
      end

  end
end