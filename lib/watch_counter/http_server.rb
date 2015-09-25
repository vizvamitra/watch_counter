module WatchCounter
  class HttpServer < ::Sinatra::Base

    helpers do
      def storage
        WatchCounter::Settings.get(:storage)
      end
    end

    configure :development, :production do
      enable :logging
      disable :run
    end

    # TODO: remove this one
    get '/watches' do
      customer_id, video_id = params['customer_id'].to_s, params['video_id'].to_s
      halt 422 if customer_id.empty? || video_id.empty?
      storage.register_watch(customer_id, video_id)
      storage.get_db.to_json
    end

    post '/watches' do
      customer_id, video_id = params['customer_id'].to_s, params['video_id'].to_s
      halt 422 if customer_id.empty? || video_id.empty?
      storage.register_watch(customer_id, video_id)
      status 204
    end

    get '/customers/:id' do
      count = storage.get_video_count_for(params['id'])
      "{\"watches\": #{count}}"
    end

    get '/videos/:id' do
      count = storage.get_customer_count_for(params['id'])
      "{\"watches\": #{count}}"
    end

  end
end