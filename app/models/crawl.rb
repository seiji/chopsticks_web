module Crawling
    def self.included(receiver)
      receiver.class_eval do
        field :title, type: String
        field :feed_url, type: String
        field :status_code, type: Integer
        field :has_new, type: Boolean
        validates_presence_of :feed_url
        validates_presence_of :status_code
        validates_presence_of :new_record
      end
    end
end

class Crawl
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Crawling

  index({ feed_url: 1 }, { unique: false,  background: true })

end

