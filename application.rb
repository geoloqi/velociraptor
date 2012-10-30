# Set a environment if one does not exist
ENV['RACK_ENV'] ||= 'development'

# Set default encodings
Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'

# Sync stdout for foreman/heroku
$stdout.sync = true

# Require gems
require 'rubygems'
require 'bundler/setup'
Bundler.require

# Start
puts "Starting in #{ENV['RACK_ENV']} mode.."

# Load libs helpers and models
Dir.glob(%w{lib/** helpers models}.map! {|d| File.join d, '*.rb'}).each {|f| require_relative f}

# Start setting up our application by extending Sinatra::Base
class Application < Sinatra::Base

  # Load Configuration Variables  
  @@config = Hashie::Mash.new YAML.load_file('./config/config.yaml')[ENV['RACK_ENV'].to_s]
  def self.Config
    @@config
  end

  def self.production?
    ENV['RACK_ENV'] == 'production'
  end

  def self.develpoment?
    ENV['RACK_ENV'] == 'development'
  end
  
  register Sinatra::Flash
  helpers  Sinatra::UserAgentHelpers

  set :root,            File.dirname(__FILE__)
  set :views,           'views'
  set :public_folder,   'public'
  set :erubis,          :escape_html => true
  set :sessions,        true
  set :session_secret,  @@config.session_secret

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
  
  # Setup Sprockets
  set :sprockets,     Sprockets::Environment.new(root)
  set :precompile,    [ /\w+\.(?!js|css).+/, /application.(css|js)$/ ]
  set :assets_prefix, "/assets"
  set :digest_assets, false
  set(:assets_path)   { File.join public_folder, assets_prefix }
  
  configure do
    # Setup Sprockets
    sprockets.append_path File.join(root, "assets", "css")
    sprockets.append_path File.join(root, "assets", "js")
    sprockets.append_path File.join(root, "assets", "img")

    # Configure Sprockets::Helpers (if necessary)
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
    end
  end

  helpers do
    include Sprockets::Helpers
  end

  # Configure Compass so it can find images
  Compass.configuration do |compass|
    compass.project_path = assets_path
    compass.images_dir   = 'img'
    compass.output_style = ENV['RACK_ENV'] == 'production' ? :compressed : :expanded
  end

  # Params Shortcut
  def p
    Hashie::Mash.new params
  end

end

# Require Controllers
require_relative './controller.rb'
Dir.glob(['controllers'].map! {|d| File.join d, '*.rb'}).each do |f| 
  require_relative f
end