# use Rack::Session::Redis, {
#   :url          => "redis://localhost:6379/0",
#   :namespace    => "rack:session",
#   :expire_after => 600
# }

module Sinatra
  module Auth
    module Helpers
      def authorized?
        session[:authorized]
      end

      def authorize!
        redirect '/' unless authorized?
      end

      def logout?
        session[:authorized] = false
      end
    end

    def self.registered(app)
      app.helpers Auth::Helpers
      app.set :username, 'frank'
      app.set :password, 'changeme'
      
      app.get '/login' do
        session[:authorized] = 'seiji'
        redirect '/home'
      end
    end
  end
  register Auth
end
