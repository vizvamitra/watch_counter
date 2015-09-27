module WatchCounter
  class HttpServer < ::Sinatra::Base

    helpers do
      def storage
        WatchCounter.app.storage
      end
    end

    configure :development, :production do
      enable :logging
      disable :run
    end

    post '/watches' do
      customer_id, video_id = params['customer_id'].to_s, params['video_id'].to_s
      halt 422 if customer_id.empty? || video_id.empty?
      storage.register_watch(customer_id, video_id)
      status 204
    end

    get '/customers/:id' do
      count = storage.get_watches_for_customer(params['id'])
      "{\"watches\": #{count}}"
    end

    get '/videos/:id' do
      count = storage.get_watches_for_video(params['id'])
      "{\"watches\": #{count}}"
    end

  end
end