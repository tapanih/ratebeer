Rails.application.routes.draw do
  resources :styles
  resources :beer_clubs
  resources :users do
    post 'toggle_closed', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :memberships, only: [:new, :create, :destroy] do
    post 'confirm', on: :member
  end

  resources :places, only: [:index, :show]

  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  post 'places', to: 'places#search'

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'

  # Defines the root path route ("/")
  root "breweries#index"

end
