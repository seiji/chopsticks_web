namespace :mongod do
  desc "setup"
  task :setup => :environment do |t|
    # TODO get from config
    session = Moped::Session.new([ "127.0.0.1:27017" ])
    session.use "flot"
    session.command(create: "crawl", capped: true, size: 10000000, max: 1000)
  end
end
