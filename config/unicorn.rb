# define paths and filenames
env = ENV['RACK_ENV'] || 'production'

if env == 'production'
  deploy_to = "/var/www/flot.in"
  rack_root = "#{deploy_to}/current"
  pid_file = "#{deploy_to}/shared/pids/unicorn.pid"
  socket_file= "#{deploy_to}/shared/unicorn.sock"
  log_file = "#{deploy_to}/shared/log/unicorn.log"
  err_log  = "#{deploy_to}/shared/log/unicorn_error.log"

  worker_processes 2

else
  rack_root   = `pwd`.gsub("\n", "")
  pid_file    = "#{rack_root}/log/unicorn.pid"
  socket_file = "#{rack_root}/log/unicorn.sock"
  log_file    = "#{rack_root}/log/unicorn.log"
  err_log     = "#{rack_root}/log/unicorn_error.log"  

  worker_processes 1

end

old_pid = pid_file + '.oldbin'

listen socket_file, :backlog => 1024

pid pid_file
stderr_path err_log
stdout_path log_file

# make forks faster
preload_app true 

# make sure that Bundler finds the Gemfile
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{rack_root}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  # zero downtime deploy magic:
  # if unicorn is already running, ask it to start a new process and quit.
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # re-establish activerecord connections.
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end


# namespace :deploy do
#   task :start, :roles => :app do
#     run "god start resque-worker"
#   end
  
#   task :restart, :roles => :app do
#     run "god restart resque-worker"
#   end
  
#   task :stop, :roles => :app do
#     run "god stop resque-worker"
#   end
# end
