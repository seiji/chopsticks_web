require File.dirname(__FILE__) + '/../spec_helper'
require "models/user"

shared_examples_for Contactable do
  it { should have_fields(:name) }
  it { should validate_presence_of(:name) }
end

describe User, "has some fields" do
  it_behaves_like Contactable
end

