module Contactable
  def self.included(receiver)
    receiver.class_eval do
      field :name, type: String
      validates_presence_of :name
      has_many :feeds, validate: false
    end
  end
end

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Contactable
end
