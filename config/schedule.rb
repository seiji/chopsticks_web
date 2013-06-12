set :output, {:error => 'log/cron_error.log', :standard => 'log/cron.log'}

every 1.minutes do
  command "date >/tmp/whenever"
end

every :hour, :roles => [:db] do
  rake 'db:task' # will only be added to crontabs of :db servers
end
# Learn more: http://github.com/javan/whenever
