require "feedzirra"
require "models/feed"
require "models/entry"
require "models/user"
require "models/crawl"

class FeedJob
  @queue = :feed

  class << self
    def perform(feed_url, user_id = nil)
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
      # 200(includes 304)

      feed_title = zfeed.title
      feed_title.gsub!(/\n/, '')
      feed_link = zfeed.url
      feed_url = url
      feed_etag = zfeed.etag
      feed_last_modified = zfeed.last_modified || Time.parse("9999-01-01T00:00:00.000Z")

      feeds = Feed.where({feed_url: feed_url})
      feed = feeds.first

      schedule_divisor = 1
      if feed
        schedule_divisor = feed.schedule_divisor || 1
      end
      feed = feeds.find_and_modify(
                                   { '$set'  => {
                                       title: feed_title,
                                       url: feed_link,
                                       etag: feed_etag,
                                       last_modified: feed_last_modified,
                                       schedule_divisor: schedule_divisor
                                     },
                                     '$inc'     => {subscriber_count: 1}
                                   },
                                   {
                                     'upsert' => 'true',
                                     :new     => true,
                                   })

      has_new = update_entries?(feed, zfeed)
      if user_id
        user = User.find(user_id)
        if user and !user.feeds.where(feed_url: feed_url).first
          user.feeds << feed
          user.save
        end
      end
      write_crawl_log(url, 200, has_new, feed_title)

    end

    def on_failure_feed(url, response_code, response_header, response_body)
      puts "Failure:: #{response_code} #{zfeed.url}"

      case response_code
      when 404
        # TODO: delete feed
      end
      write_crawl_log(url, response_code)
    end
    
    def update_entries?(feed, zfeed)
      zfeed.sanitize_entries!
      has_new = false

      zfeed.entries.each do | zentry |
        entry_title = zentry.title
        entry_title.gsub!(/\n/, '')
        published = zentry.published
        attributes = {
          url: zentry.url,
          title: entry_title,
          author: zentry.author,
          summary: zentry.summary,
          content: zentry.content,
        }
        attributes[:published] = published if published
#        entry = feed.entries.find_or_initialize_by(attributes)
        entry = Entry.where(url: zentry.url).first
        unless entry
          has_new = true
          puts "- [NEW] #{entry_title}"
          entry = Entry.new attributes
          feed.entries << entry
          write_pubsub_message(feed, entry) 
        else
          puts "-       #{entry_title}"
          entry.update_attributes attributes
        end
        entry.save!
      end
      feed.save!
      has_new
    end

    def write_crawl_log(url, status_code, has_new = false, title = nil)
      Crawl.create!(
                    title: title,
                    feed_url: url,
                    status_code: status_code,
                    has_new: has_new
                   )
    end

    def write_pubsub_message(feed, entry)
      message = "#{entry.url}\n#{entry.title} - [#{feed.title[0, 20]}]\n"
      session = Moped::Session.new([ "127.0.0.1:27017" ])
      session.use "pubsub"
      session[:seijit].insert(message: message,
                              _id:(Time.now.to_f * 1000.0).to_i,
                              formats: {
                                "0" => ["underline"],
                                "1" => ["bold", "aqua"]
                              })

      # if %w(iphone android).any? {|word| /#{word}/i =~ feed.title or /#{word}/i =~ entry.title}
      #   session[:crashlogs].insert(message: message, _id:(Time.now.to_f * 1000.0).to_i)
      # end
    end
  end
end
