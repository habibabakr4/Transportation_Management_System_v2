Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post 'signup', to: 'auth#signup'
  post 'login', to: 'auth#login'
  resources :trucks, only: [:index] do
    post 'assign', on: :member
  end
  
  get 'my_trucks', to: 'trucks#my_trucks'
  # Defines the root path route ("/")
  # root "articles#index"
end
