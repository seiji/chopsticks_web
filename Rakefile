#!/usr/bin/env rake
# Add files as lib/tasks/*.rake
require 'bundler'
Bundler.require(:default)

$:.unshift 'lib'
$:.unshift 'app'

task :environment do
  require File.expand_path(File.join(*%w[ config environment ]), File.dirname(__FILE__))
end

require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['TERM_CHILD'] = '1'
  ENV['QUEUE'] = '*'
  ENV['INTERBAL'] = '1'
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"

Dir.glob('lib/tasks/**/*.rake').each { |r| load r }
