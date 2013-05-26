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
    file = File.open(args[:file], 'r')
    # FeedImporter.import(file) do |f|
    #   puts %Q{Importing "#{f.title}"}
    # end
    file.close
  end

  desc "Import feeds from JSON"
  task :import_json, [:file] => :environment do |t, args|
    user = User.where(:name => 'seiji').first
    file = File.open(args[:file], 'r')
    hash = JSON.parser.new(file.read).parse
    hash['subscriptions'].each do |feed|
      feed_url = feed['id'].sub(/^feed\//, '')
      Resque.enqueue(FeedJob, feed_url, user.id)
    end
    # FeedImporter.import(file) do |f|
    #   puts %Q{Importing "#{f.title}"}
    # end
    file.close
  end

  desc "List all feeds"
  task :list => :environment do
    puts "Show your feed list."
    Feed.each do |feed|
      puts "#{feed.title} - #{feed.feed_url}"
      feed.entries.each do |entry|
        puts "  #{entry.title} - #{feed.url}"
      end
    end
  end

  desc "Add a feed"
  task :add, [:feed_url] => :environment do |t, args|
    Feed.add(args[:feed_url])
  end

  desc "Add a feed now"
  task :addf, [:feed_url] => :environment do |t, args|
    user = User.where(:name => 'seiji').first

    FeedJob.perform(args[:feed_url], user.id)
  end

end

