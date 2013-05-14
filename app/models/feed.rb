require "jobs/feed_job"

module Descriptive
  def self.included(receiver)
    receiver.class_eval do
      field :title, type: String
      field :url, type: String
      field :link, type: String
      field :description, type: String
      field :subscriber_count, type:Integer
      validates_presence_of :title
      validates_presence_of :link
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
  index({ url: 1 }, { unique: true,  background: true })
  index({ link: 1 }, { unique: true,  background: true })

  class << self
    def add (url)
      feed = self.where(url: url).first
      unless feed
        add_async(url)
      end
      feed
    end

    def add_async(url)
      Resque.enqueue(FeedJob, url)
    end
  end
end

