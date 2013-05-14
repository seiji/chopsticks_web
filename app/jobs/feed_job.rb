require "feedzirra"
require "models/feed"

class FeedJob
  @queue = :feed

  class << self
    def perform(feed_url)
      feed_response = fetch feed_url
      feed = Feed.where({feed_url: feed_url}).find_and_modify({ '$set'  => {
                                                                  title: feed_response.title,
                                                                  url: feed_response.url,
                                                                  etag: feed_response.etag,
                                                                },
                                                                '$inc'  => {subscriber_count: 1}},
                                                              {'upsert' => 'true', :new => true})

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
