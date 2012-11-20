class Application < Sinatra::Base

  before do
    add_js "libs/dojo/dojo/dojo", "application"
    add_css "screen"
  end

  # Put Routes Here
  get "/" do
    mobile_view true
    @content = Geoloqi::Pages.find 'home'
    full_title @content.title
    description @content.description
    erb :index
  end


  get "page/:id" do
    params[:id]
    p.id
  end

  post "application" do
  end
  
end