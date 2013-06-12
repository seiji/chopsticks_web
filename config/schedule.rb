set :output, {:error => 'log/cron_error.log', :standard => 'log/cron.log'}

every 1.minutes do
  command "date >/tmp/whenever"
end

# Learn more: http://github.com/javan/whenever
