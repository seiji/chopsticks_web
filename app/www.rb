class Hash
  def to_html
    [
     '<ul>',
     map { |k, v| ["<li><strong>#{k}</strong>", v.respond_to?(:to_html) ? v.to_html : "<span>#{v}</span></li>"] },
     '</ul>'
    ].join
  end
end

module Flot
  class WWW < Sinatra::Base
    register Sinatra::Namespace

    enable :sessions, :logging

    OmniAuth.config.full_host = lambda do |env|
      scheme         = env['rack.url_scheme']
      local_host     = env['HTTP_HOST']
      forwarded_host = env['HTTP_X_FORWARDED_HOST']
      forwarded_host.blank? ? "#{scheme}://#{local_host}" : "#{scheme}://#{forwarded_host}"
    end
    
    OmniAuth.config.on_failure = Proc.new do |env|
      message_key = env['omniauth.error.type']
      response = Rack::Response.new
      response.write env['omniauth.error'].inspect
      response.finish
    end
    
    OMNIAUTH_YAML = File.join(settings.root, '..', 'private', 'config',  'omniauth.yml')
    OMNIAUTH_CONFIG = YAML.load_file(OMNIAUTH_YAML)["#{settings.environment}"]

    use OmniAuth::Builder do
      provider :google_oauth2, OMNIAUTH_CONFIG['google']['key'], OMNIAUTH_CONFIG['google']['secret'],
      {
        :scope => 'userinfo.profile,http://www.google.com/reader/api'
      }
    end

    set :public_folder, "public"
    set :views, "app/views"

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

    get '/auth/:name/callback' do
      env['omniauth.auth']
      @auth = request.env['omniauth.auth'].to_html
       haml :"index2"
    end

    get '/home' do
      haml :home
    end

  end
end
