class FeedJob
  @queue = :feed
  class << self
    def perform(url)
      puts "get job #{@url}"
      #
#      c = Curl::Easy.new('http://localhost/favicon.ico')
#      c.perform
      
    end
  end
end
