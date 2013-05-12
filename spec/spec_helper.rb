$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'database_cleaner'
require "mongoid-rspec"
require "app"

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end
  
  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
