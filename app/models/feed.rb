class Feed
  include Mongoid::Documemt
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  field :title, type: String
  embedded_in :user, :inverse_of => :feeds
end
