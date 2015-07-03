Avacadoh::Application.routes.draw do
  get '/players/:id' => 'home#show_player', as: 'show_player'
  post '/players' => 'home#create_player', as: 'create_player'
  get '/' => 'home#index', as: 'index'
end
