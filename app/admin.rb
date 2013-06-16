require "models/feed"

module Flot
  class Admin < Sinatra::Base
    enable :sessions
    register Sinatra::Namespace

    set :public_folder, "public"
    set :views, "app/views/admin"

    set :sprockets, Sprockets::Environment.new

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix = '/assets'
      config.digest = true
      sprockets.append_path 'app/assets/javascripts'
      sprockets.append_path 'app/assets/stylesheets'
    end

    helpers Sprockets::Helpers
 
    get '/' do
      haml :"index"
    end

    get '/crawls' do
      haml :"crawls"
    end

    get '/feeds' do
      @feeds = Feed.all.sort("last_modified" =>  -1)
      haml :"feeds"
    end

    get '/users' do
      haml :"users"
    end
  end
end
