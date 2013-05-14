class EntryJob
  @queue = :entry
  class << self
    def perform(feed_id, feed_link)
      puts "get job #{@feed_id}"
      
    end
  end
end
