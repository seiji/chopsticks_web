require "models/feed"

namespace :feed do
  desc "Import feeds from OPML"
  task :import, [:file] => :environment do |t, args|
    file = File.open(args[:file], 'r')
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
end

