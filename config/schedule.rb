env :PATH, ENV['PATH']
LOG_FOLDER="/var/www/flot.in/shared/log"

set :output, {:error => "#{LOG_FOLDER}/cron_error.log", :standard => "#{LOG_FOLDER}/cron.log"}

#every :hour, :roles => [:db] do

every 1.hour, :roles => [:db] do
  rake 'feed:reloads'
end

# Learn more: http://github.com/javan/whenever
