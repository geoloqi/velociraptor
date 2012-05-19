web:        bundle exec rackup -p $PORT
worker:			bundle exec rake resque:work --trace QUEUE=*
scheduler:  bundle exec rake resque:scheduler --trace