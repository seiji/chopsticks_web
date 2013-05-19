module Flot

  class API < Sinatra::Base
    register Sinatra::Namespace

    namespace '/v1' do

      # feeds
      get '/users/11111/feeds' do
        'user feeds'
      end
      post '/users/11111/feeds' do
        'created'
      end
      
      get '/users/11111/entries' do
        'user entries'
      end

      put '/users/11111/entries' do
        'read this entry.'
      end
      
      # entries
      get '/feeds/22222/entries' do
        'entries'
      end
      get '/feeds/22222/entries/33333.json' do
        'a entry'
      end

      
    end
  end
end
