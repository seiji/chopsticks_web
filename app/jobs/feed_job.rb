require "feedzirra"
require "models/feed"
require "models/entry"

class FeedJob
  @queue = :feed

  class << self
    def perform(feed_url)
      zfeed = fetch feed_url
      feed = Feed.where({feed_url: feed_url}).find_and_modify({ '$set'  => {
                                                                  title: zfeed.title,
                                                                  url: zfeed.url,
                                                                  etag: zfeed.etag,
                                                                },
                                                                '$inc'  => {subscriber_count: 1}},
                                                              {'upsert' => 'true', :new => true})
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

    def fetch(feed_url)
      Feedzirra::Feed.fetch_and_parse(feed_url,
                                      :on_success => lambda {|url, feed| # note that a return status of 304 (not updated) will call the on_success handler
                                        
                                      },
                                      :on_failure => lambda {|url, response_code, responsea_header, response_body| # fail
                                        
                                      })
    end
  end
end
