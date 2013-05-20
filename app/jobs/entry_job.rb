require "models/feed"
class EntryJob
  @queue = :entry
  class << self
    def perform()
      feeds = Feed.where(:subscriber_count.gte => 1)
      feeds.map {|f| update f }
    end

    def update(feed)
      zfeed = Feedzirra::Feed.fetch_and_parse(feed.feed_url)
      feed = Feed.where({feed_url: feed.feed_url}).find_and_modify({ '$set'  => {
                                                                  title: zfeed.title,
                                                                  url: zfeed.url,
                                                                  etag: zfeed.etag,
                                                                }},
                                                              {'upsert' => 'true', :new => false})
      zfeed.sanitize_entries!
      zfeed.entries.each do | zentry |
        entry = feed.entries.find_or_create_by(
                                               url: zentry.url,
                                               title: zentry.title,
                                               author: zentry.author,
                                               summary: zentry.summary,
                                               content: zentry.content,
                                               )
        entry.save
      end
      feed.save!
    end

    def bulk_update(feeds)
    end
  end
end
