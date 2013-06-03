require "models/feed"
class EntryJob
  @queue = :entry
  class << self
    def perform()
      feeds = Feed.where(:subscriber_count.gte => 1)
      feeds.map {|f| FeedJob.reload f }
    end
  end
end
