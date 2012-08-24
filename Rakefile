ENV['RACK_ENV'] ||= 'development'
Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'
$stdout.sync = true
require 'rubygems'
require 'bundler/setup'
Bundler.require

Dir.glob(%w{lib/** helpers models}.map! {|d| File.join d, '*.rb'}).each {|f| require_relative f}
CONFIG = Hashie::Mash.new YAML.load_file('./config/config.yaml')[ENV['RACK_ENV'].to_s]

# Initialize MongoID
Mongoid.load!(File.join(File.dirname(__FILE__),"config","mongoid.yaml"))
Mongoid.logger = Logger.new($stdout, :info) if ENV['RACK_ENV'] == "development"

require 'resque/tasks'
require 'resque_scheduler/tasks'

desc "Setup and configure Resque"
task "resque:setup" do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  REDIS = Redis.new_from_yaml(File.join(File.dirname(__FILE__),"config","redis.yaml"));
  Resque.redis = REDIS
  Resque.schedule = YAML.load_file('./config/resque_schedule.yaml')
end

desc "Alias `resque:work` to `jobs:work`"
task "jobs:work" => "resque:work"

namespace :compass do
	
	desc "Watch Compass project in `/assets` for changes"
	task :watch do
		`bundle exec compass watch ./assets`
	end
	
	desc "Compile Compass project in `/assets`"
	task :compile do
		`bundle exec compass compile ./assets`
	end

end

task :default do
  puts "All available rake tasks"
  system('rake -T')
end