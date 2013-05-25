module Flot
  class WWW < Sinatra::Base
    enable :sessions, :logging
    OMNIAUTH_YAML = File.join(settings.root, '..', 'private', 'config',  'omniauth.yml')
    OMNIAUTH_CONFIG = YAML.load_file(OMNIAUTH_YAML)["#{settings.environment}"]

    #OmniAuth.config.logger = Rails.logger

    use OmniAuth::Builder do
      provider :google_oauth2, OMNIAUTH_CONFIG['google']['key'], OMNIAUTH_CONFIG['google']['secret'],
      {
        :access_type => 'offline',
        :scope => 'http://www.google.com/reader/api'
      }
    end

    set :public_folder, "public"
    set :views, "app/views"

    get '/' do
      haml :"index"
    end

    get '/auth/:name/callback' do
      @auth = request.env['omniauth.auth']
      haml :index2
    end
  end
end
