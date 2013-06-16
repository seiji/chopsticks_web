$:.unshift 'app'
$:.unshift 'config'

require 'bundler'
Bundler.require

require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))

require "www"
require 'api'
require 'admin'

if ENV['RACK_ENV'] == 'development'
  require 'rack/contrib/profiler'
  use Rack::Profiler
end

map '/assets' do
  run Flot::WWW.sprockets
end

map '/' do
  run Flot::WWW
end

map '/api' do
  run Flot::API
end

map '/admin' do
  run Flot::Admin
end

