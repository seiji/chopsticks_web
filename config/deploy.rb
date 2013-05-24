set :application, "flot.in"
set :repository, "git://github.com/seiji/flot.git"
set :branch, fetch(:branch, "master")

set :scm, "git"
set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }

set :user, "deploy"
set :group, user
set :runner, user

set :deploy_via, :remote_cache

set :host, "#{user}@flot.in"
role :web, host
role :app, host

set :rails_env, :production

# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :deploy_to, "/var/www/#{application}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
