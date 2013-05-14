Mongoid.load!(File.join(File.dirname(__FILE__), '..', 'config', 'mongoid.yml'), 'development')

#Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
Resque.logger = Logger.new('log/resque.log')
Resque.logger.level = Logger::DEBUG
