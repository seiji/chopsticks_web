require 'bundler'
Bundler.require(:test)
require 'rspec'
require 'database_cleaner'
require "mongoid-rspec"
require 'simplecov'
#require 'rack/test'

require File.expand_path("../../config/environment", __FILE__)

RSpec.configure do |config|
  config.include Mongoid::Matchers
  config.include Rack::Test::Methods
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end
  
  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end
  
end

SimpleCov.start do
  add_group "app", "/app"
  add_filter "/spec/"
  add_filter "/vendor/bundle/"
end if ENV["COVERAGE"]

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
