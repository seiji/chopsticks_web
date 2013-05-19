module Contactable
  def self.included(receiver)
    receiver.class_eval do
      field :name, type: String
      field :latest, type: DateTime
      validates_presence_of :name
    end
  end
end

require_relative "feed"
require_relative "user_entry"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Contactable

  validates_uniqueness_of :name
  has_and_belongs_to_many :feeds do 
    def find_by_feed_url(feed_url)
      @target.select { |feed| feed.feed_url == feed_url}.first
    end
  end
  index({ name: 1 }, { unique: true,  background: true })

  # User
  class << self
    def register(name)
      self.where(name: name).create
    end    
  end

  def withdraw
  end

  # Feed
  def subscribe (feed_url)
    Feed.add(feed_url, self)
  end

  def unsubscribe(feed)
    if self.feeds.delete(feed)
      feed.inc(:subscriber_count, -1)
    end
  end

  # Entry
  def entries
    self.feeds.entries
    # TODO: tuning
    entries = self.feeds.inject([]) {|entries, feed| entries + feed.entries }
    entries
  end

  def read(entry_id)
    UserEntry.read(self.id, entry_id)
  end
end
