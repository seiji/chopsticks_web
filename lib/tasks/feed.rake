require "models/feed"
require "models/user"
require "jobs/feed_job"

namespace :user do
  desc "Create User"
  task :register, [:name] => :environment do |t, args|
    name = args[:name]
    user = User.register(name)
    puts user.name
  end
end

namespace :feed do
  desc "Import feeds from OPML"
  task :import, [:file] => :environment do |t, args|
    File.open(args[:file], 'r') do |file|
      # FeedImporter.import(file) do |f|
      #   puts %Q{Importing "#{f.title}"}
      # end
    end
  end

  desc "Import feeds from JSON"
  task :import_json, [:file] => :environment do |t, args|
    user = User.where(:name => 'seiji').first
    return unless user

    File.open(args[:file], 'r') do |file|
      hash = JSON.parser.new(file.read).parse
      feed_urls = hash['subscriptions'].map do |feed|
        feed['id'].sub(/^feed\//, '')
      end
      FeedJob.perform(feed_urls, user.id)

      # Resque.enqueue(FeedJob, feed_url, user.id)
    end
  end

  desc "List all feeds"
  task :list => :environment do
    puts "Show your feed list."
    Feed.each do |feed|
#      puts "#{feed.title} - #{feed.feed_url}"
      print "\e[32m#{feed.title}\e[0m"
      print "[\e[36m#{feed.feed_url}\e[0m]\n"
      # feed.entries.each do |entry|
      #   puts "  #{entry.title} - #{feed.url}"
      # end
    end
  end

  desc "Add a feed"
  task :add, [:feed_url] => :environment do |t, args|
    Feed.add(args[:feed_url])
  end

  desc "Add a feed now"
  task :addf, [:feed_url] => :environment do |t, args|
    user = User.where(:name => 'seiji').first
    if user
      FeedJob.perform(args[:feed_url], user.id)
    end
  end

  desc "Reload a feed"
  task :reload, [:feed_url] => :environment do |t, args|
    feed = Feed.where(:feed_url => args[:feed_url]).first
    if feed
      FeedJob.reload(feed)
    end
  end
end

