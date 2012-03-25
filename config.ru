require './environment.rb'

map '/' do
  run Controller
end

Controller.controller_names.each do |controller_name|
  map "/#{controller_name}" do
    eval "run #{controller_name.capitalize}"
  end
end