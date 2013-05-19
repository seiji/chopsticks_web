require File.dirname(__FILE__) + '/../spec_helper'
require "resque_spec"
require "jobs/feed_job"
require "models/feed"

describe FeedJob do
  before(:each) do
    @user = User.register("TestMan")
    @feed_url = 'http://blog.seiji.me/atom.xml'
  end

  describe "#enqueue" do
    before do
      ResqueSpec.reset!
    end
    it "should enqueue feed to the Feed queue" do
      Resque.enqueue(FeedJob, @feed_url, @user.id)
      FeedJob.should have_queued(@feed_url, @user.id).in(:feed)
      FeedJob.should have_queue_size_of(1)
    end
  end                           # #enqueue

  describe "#fetch" do
    it 'should get a response from a feed' do
      VCR.use_cassette 'jobs/feed_job/response' do
        feed = FeedJob.fetch(@feed_url)
        feed.title.should == %q(\x6d\x65\x6d\x6f\x6e)
      end
    end
  end                           # #request

  describe "#perform" do
    it 'should perform feedjob' do
      VCR.use_cassette('jobs/feed_job/response', :record => :new_episodes) do
        FeedJob.perform(@feed_url, @user.id)
        feeds = Feed.where(feed_url: @feed_url)
        feeds.count.should == 1
        feeds.first.entries.count.should == 20
      end
    end
  end                           # #perform
end
