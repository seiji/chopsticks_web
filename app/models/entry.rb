module Summary
    def self.included(receiver)
      receiver.class_eval do
        field :title, type: String
        field :link, type: String
        field :summary, type: String
        field :reads, type: Integer
        validates_presence_of :title
        validates_presence_of :link
        belongs_to :feed, touch: true
      end
    end
end

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps
  include Summary
end
