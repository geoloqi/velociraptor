require './environment.rb'
# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'

desc "Setup Resque"
task "resque:setup" do
  require 'resque'
  require 'resque_scheduler'
  require 'resque/scheduler'
  Resque.schedule = YAML.load_file('./config/resque_schedule.yaml')
end

desc "Alias resque:work to jobs:work"
task "jobs:work" => "resque:work"