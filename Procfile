web:        bundle exec rackup -s puma -p $PORT -E production
worker:     bundle exec rake resque:work
scheduler:  bundle exec rake resque:scheduler
#resque:    bundle exec resque-web -p 8282
