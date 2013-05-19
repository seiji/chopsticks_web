# TODO:
# - Response code
# - Partial Response (?fields=name,title)
# - Pagination
# - Multiple formats (*.json. *.xml)
# - Authentication, OAuth 2.0
# - Chatty API (?fields=dogs.name)

module Flot
  class API < Sinatra::Base
    set :public_folder, "public"
    set :views, "app/views"
    
    mime_type :json, "application/json"    
    before do
      content_type :json
    end

    get '/' do
      haml :"index"
    end
    
  end
end

%w(v1).each { |f| require_relative "api/#{f}" }
