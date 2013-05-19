source 'https://rubygems.org'

gem 'sinatra'

gem "foreman"
gem "resque"
gem 'bson', '~> 1.8.3'
gem 'bson_ext', '~> 1.8.3'
gem "mongo"
gem 'mongoid', '~> 3.1.2'
# fail if use in rubygems
gem "feedzirra", git: "https://github.com/pauldix/feedzirra.git"
gem 'home_run', :require=>'date'

gem 'haml'
gem 'coffee-script'
gem 'sprockets', '~> 2.0'
gem 'whenever', '0.7.3'
gem 'json', '~> 1.7.7'

group :development do
  gem 'guard'
  gem 'guard-pow'
  gem 'guard-livereload'
  gem 'rb-fsevent'
end

group :test do
  gem 'rspec'
  gem "rack-test", require: "rack/test"
  gem 'simplecov'
  gem 'mongoid-rspec'
  gem 'database_cleaner'
  gem 'resque_spec'
  gem 'webmock', '~> 1.9.0'      #  VCR is known to work with WebMock >= 1.8.0, < 1.10.
  gem 'vcr'
end
