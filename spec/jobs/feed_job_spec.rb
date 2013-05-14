require File.dirname(__FILE__) + '/../spec_helper'
require "jobs/feed_job"

describe FeedJob, "#add" do
  before do
    ResqueSpec.reset!
  end
  it "adds feed.info to the Feed queue" do
    url = 'http://blog.seiji.me'
    Resque.enqueue(FeedJob, url)
    FeedJob.should have_queued(url).in(:feed)
  end
end
