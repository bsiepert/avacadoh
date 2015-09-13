Avacadoh::Application.routes.draw do
  # get '/players/:id' => 'home#show_player', as: 'show_player'
  # post '/players' => 'home#create_player', as: 'create_player'
  # get '/players' => 'home#player_index', as: 'player_index'
  get '/' => 'matches#index', as: 'index'
  post '/matches/generate' => 'matches#generate_matches', as: 'generate_matches'
  resources :players
  resources :matches
end
