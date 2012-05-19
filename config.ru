require './environment.rb'
require 'resque/server'

map '/' do
  run Controller
end


map '/resque' do
use Rack::Auth::Basic, "Protected Area" do |username, password|
  if(username == 'foo' && password == 'bar'){
		run Resque::Server.new
	}
end


end

Controller.controller_names.each do |controller_name|
  map "/#{controller_name}" do
    eval "run #{controller_name.capitalize}"
  end
end