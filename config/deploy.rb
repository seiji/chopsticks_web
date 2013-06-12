require "bundler/capistrano"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "flot.in"
set :repository, "git://github.com/seiji/flot.git"

set :scm, "git"
set :use_sudo, true

set(:run_method) { use_sudo ? :sudo : :run }

set :user, "deploy"
set :group, user
set :runner, user

set :deploy_via, :remote_cache
set :git_enable_submodules, 1

set :host, "#{user}@flot.in"
role :web, host
role :app, host
role :db, host

set :whenever_roles, :db

# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"
set :branch, fetch(:branch, "master")
set :rack_env, :production


set :deploy_to, "/var/www/#{application}"
set :current_path, "#{deploy_to}/current"
set :shared_path, "#{deploy_to}/shared"

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D; fi"
  end

  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/misc/nginx/flot.in.conf /etc/nginx/sites-enabled/#{application}"
#    run "mkdir -p #{shared_path}/config"
    # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    # puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  # task :symlink_config, roles: :app do
  #   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end
  # after "deploy:finalize_update", "deploy:symlink_config"

  
end
