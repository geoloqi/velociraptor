web:        bundle exec rackup -p $PORT -E production
worker:			bundle exec rake resque:work QUEUE=*
scheduler:  bundle exec rake resque:scheduler