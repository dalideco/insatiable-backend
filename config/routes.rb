Rails.application.routes.draw do
  apipie
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # first version
  namespace :v1 do
    resources :weapons, only: %i[create index show update destroy]
    resources :players, only: %i[create index update destroy show] do
      resources :packs, only: %i[] do
        post 'open', controller: :packs, action: :open
      end
      get 'packs', controller: :packs, action: :mine
    end

    resources :packs, only: %i[index create update destroy]
    resources :owns, only: %i[create index show update destroy]
    resources :own_packs, only: %i[create index show update destroy]
    resources :offers, only: %i[create index show update]

    # opening a pack
    # post 'players/:id/packs/:pack_id', controller: :players, action: :open
    # buying a pack
    post 'packs/:id/buy', controller: :packs, action: :buy

    scope 'auth' do
      post 'login', controller: :auth, action: :login
      get 'whoami', controller: :auth, action: :whoami
    end
  end
end
