require File.dirname(__FILE__) + '/../spec_helper'
require "models/user"
require "resque_spec"

shared_examples_for Contactable do
  it { should have_fields(:name) }
  it { should validate_presence_of(:name) }
end

describe User do
  before(:each) do
    @user = User.register("TestMan")
    @feed_url = "http://blog.seiji.me/atom.xml"
    with_resque do
      VCR.use_cassette 'models/user/blog.seiji.me' do
        @user.subscribe(@feed_url)
      end
    end
  end

  it_behaves_like Contactable
  it { should validate_uniqueness_of(:name) }
  it { should have_and_belong_to_many(:feeds)}
  it { should have_index_for(name: 1).with_options(unique: true, background: true) }

  it "should register new user" do
    @user.name.should == "TestMan"
  end

  it 'should withdraw' do
    pending "implement this."
  end

  it "should subscribe a feed" do
    new_user = User.find(@user.id)
    new_user.feeds.count.should == 1
  end

  it 'should subscribe same feed' do
    new_user = User.find(@user.id)
    new_user.feeds.count.should == 1
    with_resque do
      VCR.use_cassette 'models/user/blog.seiji.me' do
        @user.subscribe(@feed_url)
      end
    end
    new_user = User.find(@user.id)
    new_user.feeds.count.should == 1

    feed = new_user.feeds.find_by_feed_url(@feed_url)
    feed.subscriber_count.should == 1
  end

  it 'should subscribe some feed' do
    with_resque do
      VCR.use_cassette 'models/user/blog.seiji.me' do
        @user.subscribe(@feed_url)
      end
    end
    new_user = User.find(@user.id)
    new_user.feeds.count.should == 1

  end

  it 'should unsubscribe a feed' do
    new_user = User.find(@user.id)
    feed = new_user.feeds.find_by_feed_url(@feed_url)
    new_user.unsubscribe(feed)

    new_user = User.find(@user.id)
    new_user.feeds.count.should == 0

    feed = new_user.feeds.find_by_feed_url(@feed_url)
    feed.should == nil
  end

end
