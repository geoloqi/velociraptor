class Application < Sinatra::Base

  # Put Routes Here
  get "/" do
    title "Home Page"
    description "An application framework with Sinatra, MongoID, and Redis"
    add_js "application"
    add_css "screen"
    @message = "Hello visitor ##{Counter.increment.to_s} the CRON has been run #{Counter.cron.to_s} times"
    erb :index
  end

end