require File.dirname(__FILE__) + '/../spec_helper'

describe "TestMan logged in user" do
  
  before do
    OmniAuth.config.test_mode = true
    user = FactoryGirl.create(:user)
    OmniAuth.config.mock_auth[:google_oauth2] = {
      "uid" => "11111",
      "provider" => "google_oauth2",
      "info" => {
        "description" => "Hello Hello",
      },
    }
    visit "/auth/google_oauth2"
  end
  after do
    OmniAuth.config.test_mode = true
  end

  describe 'in items page' do
    
    
    
  end
end
