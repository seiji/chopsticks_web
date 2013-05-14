source 'https://rubygems.org'
ruby '2.0.0'

gem 'sinatra'
gem "foreman"
gem "resque"
gem 'bson', '~> 1.8.3'
gem 'bson_ext', '~> 1.8.3'
gem "mongo"
gem 'mongoid', '~> 3.1.2'
# fail if use in rubygems
gem "feedzirra", git: "https://github.com/pauldix/feedzirra.git"

gem 'haml'
gem 'coffee-script'
gem 'sprockets', '~> 2.0'
gem 'whenever', '0.7.3'
gem 'json', '~> 1.7.7'

group :development do
  gem 'guard'
  gem 'guard-livereload'
  gem 'rb-fsevent'
end

group :test do
  gem 'rspec'
  gem 'simplecov'
  gem 'mongoid-rspec'
  gem 'database_cleaner'
  gem 'resque_spec'
end
