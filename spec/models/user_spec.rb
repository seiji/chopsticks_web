require File.dirname(__FILE__) + '/../spec_helper'
require "models/user"

shared_examples_for Contactable do
  it { should have_fields(:name) }
  it { should validate_presence_of(:name) }
end

describe User do
  it_behaves_like Contactable
  it { should validate_uniqueness_of(:name) }
  it { should have_and_belong_to_many(:feeds)}
  it { should have_index_for(name: 1).with_options(unique: true, background: true) }

  it "should register new user" do
    user = User.register("TestMan")
    user.name.should == "TestMan"
  end

  it 'should withdraw' do
    pending "implement this."
  end

  it "should subscribe a feed" do
    user = User.register("TestMan")
    feed = user.subscribe("Test Feed", "http://blog.seiji.me")
    user.feeds.count.should == 1
  end

  it 'should subscribe same feed' do
    user = User.register("TestMan")
    feed = user.subscribe("Test Feed", "http://blog.seiji.me")
    user.feeds.count.should == 1
    feed = user.subscribe("Test Feed1", "http://blog.seiji.me")
    user.feeds.count.should == 1
    feed.subscriber_count.should == 1
  end

  it 'should subscribe some feed' do
    user = User.register("TestMan")
    feed = user.subscribe("Test Feed", "http://blog.seiji.me")
    user.feeds.count.should == 1
    feed = user.subscribe("Test Feed1", "http://blog.seiji.me/test")
    user.feeds.count.should == 2
  end

  it 'should unsubscribe a feed' do
    user = User.register("TestMan")
    feed = user.subscribe("Test Feed", "http://blog.seiji.me")
    user.feeds.count.should == 1
    feed.subscriber_count.should == 1
    user.unsubscribe(feed)
    user.feeds.count.should == 0
    feed.subscriber_count.should == 0
  end

  it 'should unsubscribe same feed' do
    user = User.register("TestMan")
    feed = user.subscribe("Test Feed", "http://blog.seiji.me")
    user.feeds.count.should == 1
    feed.subscriber_count.should == 1

    user.unsubscribe(feed)
    user.feeds.count.should == 0
    feed.subscriber_count.should == 0

    user.unsubscribe(feed)
    user.feeds.count.should == 0
    feed.subscriber_count.should == 0
  end

  it 'should unsubscribe some feed' do
    user = User.register("TestMan")
    feed1 = user.subscribe("Test Feed", "http://blog.seiji.me")
    user.feeds.count.should == 1
    feed1.subscriber_count.should == 1

    feed2 = user.subscribe("Test Feed", "http://blog.seiji.me/test")
    user.feeds.count.should == 2
    feed2.subscriber_count.should == 1

    user.unsubscribe(feed1)
    user.feeds.count.should == 1
    feed1.subscriber_count.should == 0

    user.unsubscribe(feed2)
    user.feeds.count.should == 0
    feed2.subscriber_count.should == 0
  end

end
