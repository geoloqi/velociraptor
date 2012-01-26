ENV['RACK_ENV'] = 'test'
raise 'Forget it.' if ENV['RACK_ENV'] == 'production'

require 'simplecov'

SimpleCov.coverage_dir File.join('spec', 'coverage')
SimpleCov.start

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'environment.rb')
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock'
Bundler.require :test

include Rack::Test::Methods
include WebMock::API

def mock_app(&block)
  @app = Sinatra.new API, &block
end

def app
  @app
end