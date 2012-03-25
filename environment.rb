ENV['RACK_ENV'] ||= 'development'
Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require

puts "Starting in #{ENV['RACK_ENV']} mode.."

Dir.glob(%w{lib/** helpers models}.map! {|d| File.join d, '*.rb'}).each {|f| require_relative f}

class Controller < Sinatra::Base
  
  register Sinatra::Flash
  helpers  Sinatra::UserAgentHelpers
  
  # Set Sinatra Root
  set :root,            File.dirname(__FILE__)
  set :views,           'views'
  set :public_folder,   'public'
  set :erubis,          :escape_html => true
  set :sessions,        true
  set :session_secret,  'PUT SOMETHING HERE'

  # Load Configuration Variables  
  @_config = Hashie::Mash.new YAML.load_file('./config/config.yaml')[ENV['RACK_ENV'].to_s]
  def self.Settings
    @_config
  end

  # Development Specific Configuration
  configure :development do
    Bundler.require :development
    use Rack::ShowExceptions
  end

  # Test Specific Configuration
  configure :test do
    Bundler.require :test
  end

  # Production Specific Configuration
  configure :production do

    Bundler.require :production
  end

  # Set controller names so we can map them in the config.ru file.
  set :controller_names, []
  Dir.glob('controllers/*.rb').each do |file|
    settings.controller_names << File.basename(file, '.rb')
  end

  # Params Shortcut
  def p; params end

  # Initialize MongoID
  Mongoid.load!(File.join(settings.root,"config","mongoid.yaml"))
  Mongoid.logger = Logger.new($stdout, :info)

  # Initialize Redis and Resque
  configure do
    redis_config = URI.parse(YAML.load_file(File.join(settings.root,"config","redis.yaml"))[ENV['RACK_ENV']]['redis_url'])
    REDIS = Redis.new(:host => redis_config.host, :port => redis_config.port, :password => redis_config.password)
    Resque.redis = REDIS
  end

end

# Require Controllers
require_relative './controller.rb'
Dir.glob(['controllers'].map! {|d| File.join d, '*.rb'}).each do |f| 
  require_relative f
  
  # Ugly fix to include the asset code until the inheritance bug is fixed.
  (Controller.controller_names << 'controller').each do |controller|
    eval "#{controller.capitalize}.send(:include, Assets)"
  end
end