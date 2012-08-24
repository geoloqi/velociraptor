class Widgets < Application
  
  # Put Routes Here
  get "/" do
    title "Widget Page"
    description "Look at our wonderful collection of widgets."
    @message = "Hello visitor ##{Counter.increment.to_s} the CRON has been run #{Counter.cron.to_s} times"
    erb :index
  end

end