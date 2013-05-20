require 'bundler'
Bundler.require

require 'rspec'
require 'database_cleaner'
require "mongoid-rspec"
require 'simplecov'
require 'rack/test'
require "vcr"
require "feedzirra"
require 'coveralls'

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

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.ignore_hosts('localhost', '127.0.0.1')
end

SimpleCov.start do
  puts 'simplecov start'
  add_group "app", "/app"
  add_filter "/spec/"
  add_filter "/vendor/bundle/"
end if ENV["COVERAGE"]

Coveralls.wear!

# vcr does not support for Curl::Multi
module Feedzirra
  class Feed
    class << self
      def fetch_and_parse_alt(urls, options = {})
        c = Curl.get(urls) do|http|
          
        end
        xml = decode_content(c)
        klass = determine_feed_parser_for_xml(xml)
        if klass
          begin
            feed = klass.parse(xml, Proc.new{|message| warn "Error while parsing [#{url}] #{message}" })
            feed.feed_url = c.last_effective_url
            feed.etag = etag_from_header(c.header_str)
            feed.last_modified = last_modified_from_header(c.header_str)
          end
        end
        feed
      end

      alias_method :fetch_and_parse_org, :fetch_and_parse
      alias_method :fetch_and_parse, :fetch_and_parse_alt
    end
  end
    
end
