$:.unshift 'config'

require 'application'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  run environment
end

map '/' do
  run App
end
