Avacadoh::Application.routes.draw do
  # get '/players/:id' => 'home#show_player', as: 'show_player'
  # post '/players' => 'home#create_player', as: 'create_player'
  # get '/players' => 'home#player_index', as: 'player_index'
  get '/' => 'events#index', as: 'index'
  post '/events/:id/create_round' => 'events#create_round', as: 'create_event_round'
  get '/register_players/:id' => 'events#register_players', as: 'register_players'
  post '/register_players/:id' => 'events#register_players', as: 'create_registrations'
  resources :players
  resources :events do
    resources :matches
  end
end
