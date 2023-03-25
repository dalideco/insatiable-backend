Rails.application.routes.draw do
  apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # first version
  namespace :v1 do
    resources :weapons, only: %i[create index show update destroy]
    resources :players, only: %i[create index update destroy show]
    resources :owns, only: %i[create index show update destroy]
    resources :packs, only: %i[create index show update destroy]
    resources :own_packs, only: %i[create index show update destroy]
    resources :offers, only: %i[create index show update]

    # own_packs
    post 'own_packs/:id/open', controller: :own_packs, action: :open
    # buying a pack
    post 'packs/:id/buy', controller: :packs, action: :buy

    scope 'auth' do
      post 'login', controller: :auth, action: :login
    end
  end
end
