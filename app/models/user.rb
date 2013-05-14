module Contactable
  def self.included(receiver)
    receiver.class_eval do
      field :name, type: String
      field :latest, type: DateTime
      validates_presence_of :name
    end
  end
end

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Contactable

  validates_uniqueness_of :name
  has_and_belongs_to_many :feeds
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
  def subscribe (title, link, description = nil)
    feed = self.feeds.where(link: link).first
    unless feed
      feed = Feed.where({link: link}).find_and_modify({ '$set'  => {title: title, description: description},
                                                        '$inc'  => {subscriber_count: 1}},
                                                      {'upsert' => 'true', :new => true})
      self.feeds << feed
    end
    feed
  end

  def unsubscribe(feed)
    if self.feeds.delete(feed)
      feed.inc(:subscriber_count, -1)
    end
  end

  # Entry
  def entries
  end
end
