# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post 'signup', to: 'auth#signup'
  post 'login', to: 'auth#login'
  # config/routes.rb
  resources :trucks, only: [:index] do
    post 'assign', on: :collection
    get 'my_trucks', on: :collection
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
