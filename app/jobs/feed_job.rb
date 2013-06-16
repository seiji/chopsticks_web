require "feedzirra"
require "models/feed"
require "models/entry"
require "models/user"

class FeedJob
  @queue = :feed

  class << self
    def perform(feed_url, user_id)
      Feedzirra::Feed.fetch_and_parse(feed_url,
                                      :on_success => lambda {|url, zfeed|
                                        on_success_feed(url, zfeed, user_id)
                                      },
                                      :on_failure => lambda {|url, response_code, response_header, response_body|
                                        on_failure_feed(url, response_code, response_header, response_body)
                                      })
    
    end

    def reload(feed)
      Feedzirra::Feed.fetch_and_parse(feed.feed_url,
                                      :if_modified_since => feed.last_modified,
                                      :if_none_match     => feed.etag,
                                      :on_success        => lambda {|url, zfeed|
                                        on_success_feed(url, zfeed)
                                      },
                                      :on_failure        => lambda {|url, response_code, response_header, response_body|
                                        on_failure_feed(url, response_code, response_header, response_body)
                                      })
    end

    private
    def on_success_feed(url, zfeed, user_id=nil)
      puts "Success: #{url}"
      # TODO: write log to capped collection
      # 200(includes 304)

      feed_title = zfeed.title
      feed_title.gsub!(/\n/, '')
      feed_link = zfeed.url
      feed_url = url
      feed_etag = zfeed.etag
      feed_last_modified = zfeed.last_modified || Time.parse("9999-01-01T00:00:00.000Z")
      feed = Feed.where({feed_url: feed_url}).find_and_modify({ '$set'  => {
                                                                  title: feed_title,
                                                                  url: feed_link,
                                                                  etag: feed_etag,
                                                                  last_modified: feed_last_modified
                                                                },
                                                                '$inc'  => {subscriber_count: 1}},
                                                              {'upsert' => 'true', :new => true})
      update_entries(feed, zfeed)
      if user_id
        user = User.find(user_id)
        if user and !user.feeds.where(feed_url: feed_url).first
          user.feeds << feed
          user.save
        end
      end
    end

    def on_failure_feed(url, response_code, response_header, response_body)
      puts "Failure:: #{response_code} #{zfeed.url}"

      case response_code
      when 404
        # TODO: delete feed
      end
      # TODO: write log to capped collection
    end
    
    def update_entries(feed, zfeed)
      zfeed.sanitize_entries!
      zfeed.entries.each do | zentry |
        entry_title = zentry.title
        entry_title.gsub!(/\n/, '')
        puts "- #{entry_title}"
        entry = feed.entries.find_or_create_by(
                                               url: zentry.url,
                                               title: entry_title,
                                               author: zentry.author,
                                               summary: zentry.summary,
                                               content: zentry.content,
                                               )
        entry.save
      end
      feed.save!
    end
  end
end
