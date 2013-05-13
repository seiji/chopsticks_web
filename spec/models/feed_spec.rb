require File.dirname(__FILE__) + '/../spec_helper'
require "models/feed"

shared_examples_for Descriptive do
  it { should have_fields(:title) }
  it { should have_fields(:link) }
  it { should have_fields(:description) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:link) }
end

describe Feed, "has some fields" do
  it_behaves_like Descriptive
  it { should belong_to_related(:user)}
  it { should have_many_related(:entries)}
end
