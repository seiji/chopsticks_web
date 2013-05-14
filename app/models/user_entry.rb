class UserEntry
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id,  type: Moped::BSON::ObjectId
  field :entry_id, type: Moped::BSON::ObjectId
  field :read, type: Boolean, default: false
  index({ user_id: 1, entry_id: 1 }, { unique: true,  background: true })
  index({ user_id: 1, read: 1 },     { unique: false, background: true })
  validates_presence_of :user_id
  validates_presence_of :entry_id
end
