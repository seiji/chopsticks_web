require "models/feed"

class App < Sinatra::Base
#  register Sinatra::Namespace
  set :public_folder, "public"
  set :views, "app/views"

  get "/" do
    haml :"index"
  end

  # namespace "/api" do
  #   namespace "/feed" do
  #     get "/" do
  #       Feed.first.as_document.to_json
  #     end
  #     get "/entries" do
  #       Feed.first.as_document.to_json
  #     end
  #   end
  # end
end

#%w(routes).each { |f| require_relative "app/#{f}" }

