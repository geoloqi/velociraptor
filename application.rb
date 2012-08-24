# Set a environment if one does not exist
ENV['RACK_ENV'] ||= 'development'

# Set default encodings
Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'

# Sync stdout for foreman
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
  
  register Sinatra::Flash
  helpers  Sinatra::UserAgentHelpers

  # Set Sinatra Root
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

  # Params Shortcut
  def p
    Hashie::Mash.new params
  end

  # Initialize Mongoid
  Mongoid.load!(File.join(settings.root,"config","mongoid.yaml"))
  Mongoid.logger = Logger.new($stdout, :info) if ENV['RACK_ENV'] == "development"

  # Initialize Redis and Resque
  configure do
    REDIS = Redis.new_from_yaml(File.join(settings.root,"config","redis.yaml"));
    Resque.redis = REDIS
  end

  # Setup Sprockets
  set :sprockets_root,  File.dirname(__FILE__)
  set :sprockets,       Sprockets::Environment.new
  set :assets_prefix,   '/assets'
  set :assets_path,     File.join(settings.sprockets_root, settings.assets_prefix)

  configure do
    # Set paths
    settings.sprockets.append_path File.join(settings.assets_path, 'css')
    settings.sprockets.append_path File.join(settings.assets_path, 'js')
    settings.sprockets.append_path File.join(settings.assets_path, 'img')

    # Configure Compass so it can find images
    Compass.configuration do |compass|
      compass.project_path = settings.assets_path
      compass.images_dir   = 'img'
      compass.output_style = ENV['RACK_ENV'] == 'production' ? :compressed : :expanded
    end
    
    # Configure Sprockets::Helpers
    Sprockets::Helpers.configure do |config|
      config.environment = settings.sprockets
      config.prefix      = settings.assets_prefix
      config.digest      = true
      config.manifest    = Sprockets::Manifest.new(
        settings.sprockets,
        File.join(
          File.expand_path('../../public/assets', __FILE__), 'manifest.json'
        )
      )
      
      # Clean out manifest
      config.manifest.clean
      
      # Scoop up the images so they can come along for the party
      images = Dir.glob(File.join(settings.assets_path, 'images', '**', '*')).map do |filepath|
        filepath.split('/').last
      end

      # Note: .coffee files need to be referenced as .js for some reason
      javascript_files = Dir.glob(File.join(settings.assets_path, 'javascripts', '**', '*')).map do |filepath|
        filepath.split('/').last.gsub(/coffee/, 'js')
      end

      # Write the digested files out to public/assets
      config.manifest.compile(%w(style.css) | javascript_files | images)
    end
  end
end

# Require Controllers
require_relative './controller.rb'
Dir.glob(['controllers'].map! {|d| File.join d, '*.rb'}).each do |f| 
  require_relative f
end