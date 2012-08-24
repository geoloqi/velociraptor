web:        bundle exec rackup -p $PORT -E $ENVIRONMENT
worker:			bundle exec rake resque:work QUEUE=*
scheduler:  bundle exec rake resque:scheduler