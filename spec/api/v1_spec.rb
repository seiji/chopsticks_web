require File.dirname(__FILE__) + '/../spec_helper'

require "api/v1"

describe 'API::V1' do
  before(:each) do
    # cleanup database
  end

  describe 'users' do
    it 'should get own feeds' do
      get "/v1/users/11111/feeds"
      last_response.should be_ok
    end

    it 'should get own all unread entries' do
      get "/v1/users/11111/entries"
      last_response.should be_ok
    end
  end

  describe 'feeds' do
    it 'should get its entries' do
      get "/v1/feeds/22222/entries"
      last_response.should be_ok
    end
    it 'should get a entry' do
      get "/v1/feeds/22222/entries/33333.json"
      last_response.should be_ok
    end
  end

end
