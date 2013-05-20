require File.dirname(__FILE__) + '/../spec_helper'
require "resque_spec"
require "jobs/entry_job"
require "models/user"

describe EntryJob do
  before(:each) do
    @user = User.register("TestMan")
    @feed_url = 'http://blog.seiji.me/atom.xml'
    with_resque do
      VCR.use_cassette 'jobs/entry_job/blog.seiji.me' do
        @user.subscribe(@feed_url)
      end
    end
  end

  describe "#enqueue" do
    before do
      ResqueSpec.reset!
    end
    it "should enqueue entryjob to the Entry queue" do
      url = 'http://blog.seiji.me'
      Resque.enqueue(EntryJob)
      EntryJob.should have_queued().in(:entry)
      EntryJob.should have_queue_size_of(1)
    end
  end

  describe "#perform" do
    it 'should perform entry_job' do
      VCR.use_cassette('jobs/entry_job/blog.seiji.me', :record => :new_episodes) do
        with_resque do
          Resque.enqueue(EntryJob)
        end
        feed = FeedJob.fetch(@feed_url)
        feed.entries.count.should == 20
      end
    end
  end
end


