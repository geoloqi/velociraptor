require './environment.rb'
require 'resque/tasks'
require 'resque_scheduler/tasks'

desc "Setup Resque"
task "resque:setup" do
  ENV['QUEUE'] = '*'
  require 'resque/scheduler' 
  Resque.schedule = YAML.load_file('./config/resque_schedule.yaml')
end

desc "Alias resque:work to jobs:work"
task "jobs:work" => "resque:work"
