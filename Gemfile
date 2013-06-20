source 'https://rubygems.org'

gem 'sinatra', require:'sinatra/base'
gem 'sinatra-namespace'
gem 'unicorn'
gem 'foreman'
gem 'resque'
gem 'bson', '~> 1.8.3'
gem 'bson_ext', '~> 1.8.3'
gem "mongo"
gem 'mongoid', '~> 3.1.2'
gem 'feedzirra', git: "https://github.com/pauldix/feedzirra.git" # fail if use in rubygems
gem 'home_run', :require=>'date'
gem 'json', '~> 1.7.7'
gem 'omniauth-google-oauth2'
gem 'haml'
gem 'coffee-script'
gem 'rack-contrib', :git => "https://github.com/mirakui/rack-contrib.git"
gem 'rack-session-redis'
gem "sass"
gem 'sprockets', '~> 2.0'
gem 'sprockets-helpers'

gem 'whenever', '0.7.3', :require => false

group :development do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'guard'
  gem 'guard-pow'
  gem 'guard-livereload'
  gem 'guard-unicorn'
  gem 'rb-fsevent'
  gem 'ruby-prof'
end

group :test do
  gem 'rspec'
  gem 'factory_girl'
  gem 'simplecov'
  gem 'mongoid-rspec'
  gem 'database_cleaner'
  gem 'resque_spec'
  gem 'webmock', '~> 1.9.0'      #  VCR is known to work with WebMock >= 1.8.0, < 1.10.
  gem 'vcr'
  gem 'coveralls', require: false
  gem "rack-test", require:"rack/test"
  gem 'serverspec'
end
