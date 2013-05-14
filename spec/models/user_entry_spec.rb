require File.dirname(__FILE__) + '/../spec_helper'
require "models/user_entry"

describe UserEntry do
  it { should have_fields(:user_id) }
  it { should have_fields(:entry_id) }
  it { should have_fields(:read) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:entry_id) }
  it { should have_index_for(user_id: 1, entry_id: 1).with_options(unique: true, background: true) }
  it { should have_index_for(user_id: 1, read: 1).with_options(unique: false, background: true) }
end
