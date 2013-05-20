$:.unshift 'app'
$:.unshift 'config'

require 'bundler'
Bundler.require

require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))
require "www"
require 'api'


map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  run environment
end

map '/' do
  run Flot::WWW
end

map '/api' do
  run Flot::API
end


