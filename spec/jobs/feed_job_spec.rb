require File.dirname(__FILE__) + '/../spec_helper'
require "jobs/feed_job"
require "models/feed"

describe FeedJob do

  describe "#enqueue" do
    before do
      ResqueSpec.reset!
    end
    it "should enqueue feed to the Feed queue" do
      url = 'http://blog.seiji.me/atom.xml'
      Resque.enqueue(FeedJob, url)
      FeedJob.should have_queued(url).in(:feed)
      FeedJob.should have_queue_size_of(1)
    end
  end                           # #enqueue

  describe "#fetch" do
    it 'should get a response from a feed' do
      url = 'http://blog.seiji.me/atom.xml'
      VCR.use_cassette 'jobs/feed_job/response' do
        feed = FeedJob.fetch(url)
        feed.title.should == %q(\x6d\x65\x6d\x6f\x6e)
      end
    end
  end                           # #request

  describe "#perform" do
    it 'should perform feedjob' do
      feed_url = 'http://blog.seiji.me/atom.xml'
      VCR.use_cassette 'jobs/feed_job/response' do
      FeedJob.perform(feed_url)
        Feed.where(feed_url: feed_url).count.should == 1
      end
    end
  end                           # #perform
end
