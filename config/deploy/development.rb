set :branch, fetch(:branch, "master")
set :rack_env, :development

role :web, "localhost"
role :app, "localhost"
role :db,  "localhost", :primary => true
