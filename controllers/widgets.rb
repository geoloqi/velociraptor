class Widgets < Application
  
  # Put Routes Here
  get "/" do
    title "Widget Page"
    description "Look at our wonderful collection of widgets."
    @message = "Hello"
    erb :index
  end

  post "/" do
    # make a new widget
    flash[:success] = "Created a new widget!"
    redirect "widgets"
  end

end