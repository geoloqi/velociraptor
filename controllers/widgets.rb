class Widgets < Controller
  get '/?' do
    erb :'widgets/index'
  end
end