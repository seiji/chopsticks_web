module Flot
  class API < Sinatra::Base
    register Sinatra::Namespace

    namespace '/v1' do
      # feeds
      get '/users/:user_id/feeds' do |user_id|
        user = User.find(user_id)
        {
          :feeds => user.feeds 
        }.to_json
      end

      post '/users/:user_id/feeds' do |user_id|
        feed_urls = params[:feed_urls]
        user = User.find(user_id)
        feed_urls.map {|feed_url| user.subscribe(feed_url)}
        {
          :feeds => feed_urls
        }.to_json
      end
      
      get '/users/:user_id/entries' do |user_id|
        # TODO: tuning
        user = User.find(user_id)
        {
          :entries => user.entries
        }.to_json
      end

      put '/users/:user_id/entries' do |user_id|
        user = User.find(user_id)
        entry_ids = params[:entry_ids]
        if user
          entries = entry_ids.inject([]) {|entries, entry_id| entries << user.read(entry_id).entry_id}
        end
        {
          :entry_ids => entries
        }.to_json
      end
      
      # entries
      get '/feeds/:feed_id/entries' do |feed_id|
        feed = Feed.find(feed_id)
        {
          :entries => feed.entries
        }.to_json
      end

      get '/feeds/:feed_id/entries/:entry_id' do |feed_id, entry_id |
        feed = Feed.find(feed_id)
        {
          :entry => feed.entry(entry_id)
        }.to_json
      end
    end
  end
end
