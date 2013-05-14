require 'rspec'
require 'database_cleaner'
require "mongoid-rspec"
require 'simplecov'
require 'bundler'
Bundler.require(:test)

require File.expand_path("../../config/environment", __FILE__)

RSpec.configure do |config|
  config.include Mongoid::Matchers

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
