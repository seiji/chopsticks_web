require 'bundler'
Bundler.require

Mongoid.load!("config/mongoid.yml")

class App < Sinatra::Base
  set :public_folder, "public"
  set :views, "app/views"

  get "/" do
#    @users = User.all
    haml :"index"
  end
end
