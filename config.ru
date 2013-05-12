$LOAD_PATH << File.expand_path(".")
require 'app'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/javascripts'
  run environment
end

map '/' do
  run Chopsticks::App
end
