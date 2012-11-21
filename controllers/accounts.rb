class Accounts < Application
  
  # Put Routes Here
  get "/" do
    title "Account Page"
    description "Look at our account info."
    @message = "Account"
    erb :index
  end

end