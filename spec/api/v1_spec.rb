require File.dirname(__FILE__) + '/../spec_helper'

require "api"
require "models/user"
require "resque_spec"

def app
  Flot::API
end

describe 'Flot::API::V1' do
  
  before(:each) do
    @user = User.register("TestMan")
    @feed_url = 'http://blog.seiji.me/atom.xml'

    with_resque do
      VCR.use_cassette 'api/v1/blog.seiji.me' do
        @user.subscribe(@feed_url)
      end
    end
  end

  describe 'Users' do
    it 'should get his feeds' do
      get "/v1/users/#{@user.id}/feeds"
      last_response.should be_ok
      json = JSON.parse(last_response.body)
      json["feeds"][0]["feed_url"].should == @feed_url
    end

    it 'should add feeds to his feeds' do
      add_url = "https://news.ycombinator.com/rss"
      with_resque do
        VCR.use_cassette 'api/v1/news.ycombinator.com' do 
          post "/v1/users/#{@user.id}/feeds", { :feed_urls => [add_url, add_url] }
        end
      end
      last_response.should be_ok
      json = JSON.parse(last_response.body)
      json["feeds"].should == [add_url, add_url]
      
      get "/v1/users/#{@user.id}/feeds"
      last_response.should be_ok

      json = JSON.parse(last_response.body)
      json["feeds"].count.should == 2
    end
    
    it 'should get his all entries' do
      get "/v1/users/#{@user.id}/entries"
      last_response.should be_ok
      json = JSON.parse(last_response.body)
      json['entries'].count.should == 20
    end

    it 'should mark entries read' do
      get "/v1/users/#{@user.id}/entries"
      json = JSON.parse(last_response.body)
      entry_ids = (0..1).inject([]) {|entry_ids, i| entry_ids << json['entries'][i]['_id']}

      put "/v1/users/#{@user.id}/entries", { :entry_ids => entry_ids }
      last_response.should be_ok
      json = JSON.parse(last_response.body)
      json['entry_ids'].should == entry_ids
    end
  end

  describe 'Feeds' do
    it 'should get its entries' do
      get "/v1/users/#{@user.id}/feeds"
      json = JSON.parse(last_response.body)
      feed = json["feeds"][0]

      get "/v1/feeds/#{feed['_id']}/entries"
      last_response.should be_ok
      json = JSON.parse(last_response.body)
      json['entries'].count.should == 20
    end

    it 'should get a entry' do
      get "/v1/users/#{@user.id}/feeds"
      json = JSON.parse(last_response.body)
      feed = json["feeds"][0]
      
      get "/v1/feeds/#{feed['_id']}/entries"
      json = JSON.parse(last_response.body)
      entry = json['entries'][0]

      get "/v1/feeds/#{feed['_id']}/entries/#{entry['_id']}"
      last_response.should be_ok
      json = JSON.parse(last_response.body)
      json['entry']['_id'].should == entry['_id']
    end
  end
end
