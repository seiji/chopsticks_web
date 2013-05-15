require "models/feed"
require "worker"

namespace :feed do
  desc "Start worker to periodically refresh feeds"
  task :worker => :environment do
    worker_out = STDOUT
    worker_out.sync = true

    worker = Worker.new(worker_out)
    trap('TERM') { worker.stop }
    trap('INT') { exit }
    worker.start
  end

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
    Feed.each do |feed|
      puts feed
    end
  end

  desc "Add a feed"
  task :add, [:feed_url] => :environment do |t, args|
    Feed.add(args[:feed_url])
  end
end

