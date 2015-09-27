module WatchCounter
  class Config

    DEFAULT = {
      storage: {
        adapter: 'sqlite',
        stale_interval: 6
      },
      http_server: {
        bind: 'localhost',
        port: '4567'
      }
    }

    def initialize options={}
      options[:storage] = DEFAULT[:storage].merge!(options[:storage] || {})
      options[:http_server] = DEFAULT[:http_server].merge!(options[:http_server] || {})
      @options = options
    end

    def respond_to?(name, include_private = false)
      super || @options.key?(name.to_sym)
    end

    private

      def method_missing(name, *args, &blk)
        if name.to_s =~ /=$/
          @options[$`.to_sym] = args.first
        elsif @options.key?(name)
          @options[name]
        else
          super
        end
      end

  end
end