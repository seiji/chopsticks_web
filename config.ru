$:.unshift 'app'
$:.unshift 'config'

require 'bundler'
Bundler.require

require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))

require 'routes'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  run environment
end

map '/' do
  run App
end

