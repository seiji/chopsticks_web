require File.dirname(__FILE__) + '/../spec_helper'

require "api"

def app
  Flot::API
end

describe 'Flot::API::V1' do
  before(:each) do
    # cleanup database
  end

  describe 'Users' do
    it 'should get his feeds' do
      get "/v1/users/11111/feeds"
      last_response.should be_ok
    end

    it 'should add a feed to his feeds' do
      post "/v1/users/11111/feeds"
      last_response.should be_ok
    end
    
    it 'should get his unread entries' do
      get "/v1/users/11111/entries"
      last_response.should be_ok
    end

    it 'should mark entries read' do
      put "/v1/users/11111/entries"
      last_response.should be_ok
    end
    
  end

  describe 'Feeds' do
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
