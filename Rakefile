#require './environment.rb'
# Resque tasks
ENV['RACK_ENV'] ||= 'development'
Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require

puts "Starting in #{ENV['RACK_ENV']} mode.."

Dir.glob(%w{lib/** helpers models}.map! {|d| File.join d, '*.rb'}).each {|f| require_relative f}
CONFIG = Hashie::Mash.new YAML.load_file('./config/config.yaml')[ENV['RACK_ENV'].to_s]

# Initialize MongoID
Mongoid.load!(File.join(File.dirname(__FILE__),"config","mongoid.yaml"))
Mongoid.logger = Logger.new($stdout, :info) if ENV['RACK_ENV'] == "development"

require 'resque/tasks'
require 'resque_scheduler/tasks'

desc "Setup Resque"
task "resque:setup" do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  path = File.join(File.dirname(__FILE__),"config","redis.yaml")
  file = File.read(path)
  erb = ERB.new(file).result
  yaml = YAML.load(erb)[ENV['RACK_ENV']]['redis_url']
  redis_config = URI.parse(yaml)
  REDIS = Redis.new(host: redis_config.host, port: redis_config.port, password: redis_config.password)
  Resque.redis = REDIS
  Resque.schedule = YAML.load_file('./config/resque_schedule.yaml')
end

desc "Alias resque:work to jobs:work"
task "jobs:work" => "resque:work"