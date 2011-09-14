Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require
require File.join(File.expand_path(File.dirname(__FILE__)), 'helpers.rb')
Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}

puts "Starting in #{Sinatra::Base.environment} mode.."

class Controller < Sinatra::Base

  ##
  # Application specific configuration
  ##

  raise 'Configuration error: session secret (and likely other settings) are not set. Change in environment.rb and remove the raise statement'
  set :sessions,                 true
  set :session_secret,           'PUT SOMETHING HERE'
  set :geoloqi_memcache_enabled, false
  set :geoloqi_memcache_url,     '127.0.0.1:11211'
  set :geoloqi_client_id,        'PUT CLIENT ID HERE'
  set :geoloqi_client_secret,    'PUT CLIENT SECRET HERE'


  ##
  # The rest of this you shouldn't need to change (initially).
  ##

  set :raise_errors,    false
  set :show_exceptions, false
  set :method_override, true
  set :public,          'public'
  set :erubis,          :escape_html => true

  register Sinatra::Synchrony
  register Sinatra::Namespace
  register Sinatra::Flash

  Geoloqi.config :client_id => settings.geoloqi_client_id,
                 :client_secret => settings.geoloqi_client_secret,
                 :use_hashie_mash => true,
                 :adapter => :em_synchrony

  Geoloqi.config.logger = STDOUT if development?

  Faraday.default_adapter = :em_synchrony

  # async-aware Memcache client
  Cache = Dalli::Client.new(settings.geoloqi_memcache_url, :async => true) if settings.geoloqi_memcache_enabled?

  configure :development do
    use Rack::CommonLogger
    Bundler.require :development
  end

  configure :test do
  end

  configure :production do
  end

  not_found do
    erubis :'404'
  end

  error do
    # Implement error reporting such as Airbrake (formerly Hoptoad) here.
    erubis :'500'
  end
end

require File.join('.', 'controller.rb')