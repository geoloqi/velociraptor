web:        bundle exec rackup -p $PORT
worker:			QUEUE=* bundle exec rake resque:work --trace
scheduler:  bundle exec rake resque:scheduler --trace
#resque:    bundle exec resque-web -p 8282