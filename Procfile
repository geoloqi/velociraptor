web:        bundle exec rackup -p $PORT
worker:			QUEUE=* bundle exec rake environment resque:work
scheduler:  bundle exec rake resque:scheduler --trace
#resque:    bundle exec resque-web -p 8282