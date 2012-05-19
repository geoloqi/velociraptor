require './environment.rb'
require 'resque/server'

map '/' do
  run Controller
end

map '/redis' do
	run Resque::Server.new
end

Controller.controller_names.each do |controller_name|
  map "/#{controller_name}" do
    eval "run #{controller_name.capitalize}"
  end
end