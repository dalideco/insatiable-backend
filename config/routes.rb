Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # first version
  namespace :v1 do
    resources :weapons, only: %i[create index show update destroy]
    resources :players, only: %i[create index update destroy show]
    scope 'auth' do
      post 'login', controller: :auth, action: :login
    end
  end
end
