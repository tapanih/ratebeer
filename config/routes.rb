Rails.application.routes.draw do
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  
  # Defines the root path route ("/")
  root "breweries#index"

end
