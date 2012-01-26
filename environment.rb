Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require
Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}

class Controller < Sinatra::Base
  configure do
    unless File.exists? './config.yml'
      puts 'Please provide a config.yml file.'
      exit false
    end

    $config = Hashie::Mash.new YAML.load_file('./config.yml')[ENV['RACK_ENV'].to_s]

    # Enable if you need a database:
    # DB = Sequel.connect $config.database_url, max_connections: 16, encoding: 'utf8'
    # DB.loggers << Logger.new($stdout) if Sinatra::Base.development?

    # Set controller names so we can map them in the config.ru file.
    set :controller_names, []
    Dir.glob('controllers/*.rb').each do |file|
      settings.controller_names << File.basename(file, '.rb')
      require_relative "./#{file}"
    end

    disable :show_exceptions
    disable :raise_errors

    set     :session_secret, $config.session_secret
    enable  :sessions
    
    # Geoloqi client.
    register Sinatra::Geoloqi
    set :geoloqi_client_id,     $config.geoloqi_id
    set :geoloqi_client_secret, $config.geoloqi_secret
    set :geoloqi_redirect_uri,  'http://127.0.0.1:4567'
    
    # Memcache client.
    # settings.cache.get 'key'
    # settings.cache.set 'key', 'value'
    # set :cache, Dalli::Client.new
  end

  def p; params end
end

require_relative './controller.rb'
Dir.glob(['apps'].map! {|d| File.join d, '*.rb'}).each {|f| require_relative f}