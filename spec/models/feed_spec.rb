require File.dirname(__FILE__) + '/../spec_helper'
require "models/feed"

shared_examples_for Descriptive do
  it { should have_fields(:title) }
  it { should have_fields(:url) }
  it { should have_fields(:feed_url) }
  it { should have_fields(:etag) }
  it { should have_fields(:subscriber_count) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:feed_url) }
end

describe Feed do |db|
  it_behaves_like Descriptive
  it { should have_and_belong_to_many(:user)}
  it { should have_many_related(:entries)}
  it { should have_index_for(feed_url: 1).with_options(unique: true, background: true) }

  it 'should add site url' do
    feed = Feed.add('http://blog.seiji.me/atom.xml')
  end
end

