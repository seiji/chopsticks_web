require File.dirname(__FILE__) + '/../spec_helper'
require "models/entry"

shared_examples_for Summary do
  it { should have_fields(:title) }
  it { should have_fields(:url) }
  it { should have_fields(:author) }
  it { should have_fields(:summary) }
  it { should have_fields(:content) }
  it { should have_fields(:reads) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
end

describe Entry, "has some fields" do
  it_behaves_like Summary
  it { should belong_to_related(:feed)}
  it { should have_index_for(url: 1).with_options(unique: true, background: true) }
end



