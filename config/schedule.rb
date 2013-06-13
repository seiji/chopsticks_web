env :PATH, ENV['PATH']
LOG_FOLDER="/var/www/flot.in/shared/log"
set :output, {:error => "#{LOG_FOLDER}/cron_error.log", :standard => "#{LOG_FOLDER}/cron.log"}

every 1.minutes do
  command "date >/tmp/whenever"
end

# every :hour, :roles => [:db] do
#   rake 'db:task' # will only be added to crontabs of :db servers
# end
# Learn more: http://github.com/javan/whenever
