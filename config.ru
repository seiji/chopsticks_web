$:.unshift 'app'
$:.unshift 'config'

require 'bundler'
Bundler.require

require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))
require "www"
require 'api'

map '/assets' do
  run Flot::WWW.sprockets
end

map '/' do
  run Flot::WWW
end

map '/api' do
  run Flot::API
end


