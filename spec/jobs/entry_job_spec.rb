require File.dirname(__FILE__) + '/../spec_helper'
require "jobs/entry_job"

describe EntryJob, "#enqueue" do
  before do
    ResqueSpec.reset!
  end
  it "enqueue entryjob to the entry queue" do
    url = 'http://blog.seiji.me'
    Resque.enqueue(EntryJob, 1, url)
    EntryJob.should have_queued(1, url).in(:entry)
    EntryJob.should have_queue_size_of(1)
  end
end


