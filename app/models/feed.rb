require "jobs/feed_job"
require "models/user"

module Descriptive
  def self.included(receiver)
    receiver.class_eval do
      field :title, type: String
      field :url, type: String
      field :feed_url, type: String
      field :etag, type: String
      field :subscriber_count, type: Integer
      validates_presence_of :title
      validates_presence_of :feed_url
    end
  end
end

class Feed
  include Mongoid::Document
  include Mongoid::Timestamps
  include Descriptive

  has_and_belongs_to_many :user
  has_many :entries, validate: false do
    def find_by_read(read)
      @target.select { |entry| entry.read == read}
    end
    def find_by_starred(starred)
      @target.select { |entry| entry.starred == starred}
    end
  end
  index({ feed_url: 1 }, { unique: true,  background: true })

  class << self
    def add (feed_url)
      feed = self.where(feed_url: feed_url).first
#      unless feed
        add_async(feed_url)
#      end
      feed
    end

    def add_async(feed_url)
      puts "Enqueue #{feed_url}"
      Resque.enqueue(FeedJob, feed_url)
    end
  end
end

