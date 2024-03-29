Rails.application.routes.draw do
  get 'categories/name'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "my_restaurants", to: "restaurants#my_restaurants", as: :my_restaurants

  resources :restaurants do
    resources :plates, only: %i[new create index]
    resources :reviews, only: [:new, :create]
  end

  resources :plates, only: %i[show edit update]

  delete "plates/:id", to: 'plates#destroy', as: :delete_plate

  get 'plates/by_category/:category_id', to: 'plates#by_category', as: 'plates_by_category'
  # config/routes.rb
# config/routes.rb
  #get 'restaurants/_by_category/:category_id', to: 'restaurants#by_category', as: 'restaurants_by_category'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :selectedplates, only: %i[create destroy]
  resources :carts, only: %i[show] do
    resources :checkouts, only: %i[create]
  end
  resources :checkouts, only: %i[index]
  # Defines the root path route ("/")
  # root "posts#index"
end
