class Worker
  def initialize(out = nil, err = nil, options = {})
    @running = true
    @out = out || STDOUT
    @err = err || STDERR
    @verbose = options.fetch(:verbose) { true }
  end

  attr_reader :out, :err

  def start
    out.puts "Worker started"
    while @running
      work
      wait
    end
  end

  def stop
    out.puts "Worker stopped"
    @running = false
  end

  def work
    # feed = Feed.refreshable.first
    # return if feed.nil?

    # out.puts %Q(Refreshing feed #{feed.id} "#{feed.title}")
#    refresh(feed)
    out.puts "  Done"
  end
  def wait
    sleep 5
  end
  
  # def refresh(feed)
  #   feed.refresh!
  # rescue FeedRefresher::Error => error
  #   log_error(error)
  #   feed.cancel_refresh
  # rescue
  #   stop
  # end

  # def log_error(error)
  #   err.puts error.message
  #   err.puts error.original_message
  #   err.puts(*error.original_backtrace) if verbose?
  #   err.puts "Future refreshes cancelled"
  # end
end
