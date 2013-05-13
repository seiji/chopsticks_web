module Descriptive
  def self.included(receiver)
    receiver.class_eval do
      field :title, type: String
      field :link, type: String
      field :description, type: String
      validates_presence_of :title
      validates_presence_of :link
      belongs_to :user
      has_many :entries, validate: false do
        def find_by_read(read)
          @target.select { |entry| entry.read == read}
        end
        def find_by_starred(starred)
          @target.select { |entry| entry.starred == starred}
        end
      end
    end
  end
end

class Feed
  include Mongoid::Document
  include Mongoid::Timestamps
  include Descriptive
end
