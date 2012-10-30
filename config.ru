require './application.rb'
#require 'resque/server'

map '/' do
  run Application
end

Application.controller_names.each do |controller_name|
  map "/#{controller_name}" do
    eval "run #{controller_name.capitalize}"
  end
end

map Application.assets_prefix do
  run Application.sprockets
end

#map '/resque' do 
# run Resque::Server.new
#end