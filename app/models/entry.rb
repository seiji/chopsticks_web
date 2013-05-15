module Summary
    def self.included(receiver)
      receiver.class_eval do
        field :title, type: String
        field :url, type: String
        field :author, type: String
        field :summary, type: String
        field :content, type: String
        field :reads, type: Integer
        validates_presence_of :title
        validates_presence_of :url
      end
    end
end

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps
  include Summary

  belongs_to :feed, touch: true
  index({ url: 1 }, { unique: true,  background: true })
end

