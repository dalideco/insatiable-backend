# Docs for player controller routes
module PlayersControllerDocs
  extend Apipie::DSL::Concern

  api :GET, '/players'
  description 'fetch all players'
  returns code: :ok
  def index; end

  api :POST, '/players'
  description 'Signup or create a new player'
  error :conflict, 'Email already exists'
  error :bad_request, 'Bad parameters for user creation'
  param :email, String, desc: 'email of the player'
  param :password, String, desc: 'email of the player'
  param :password_confirmation, String, desc: 'Password confirmation: has to be identical to password'
  returns code: :ok do
    property :id, String, desc: 'The player\'s id'
    property :email, String, desc: 'The players Email'
    property :avatar, String, desc: 'the players avatar link', required: false
    property :confirmed_at, String, desc: 'the players avatar link', required: false
    property :created_at, String, desc: 'the players avatar link'
    property :updated_at, String, desc: 'the players avatar link'
  end
  def create; end

  api :GET, '/players/:id'
  param :id, :number, desc: 'id of the requested player'
  description 'show a player\'s information'
  error :not_found, 'Player Not Found'
  error :unauthorized, 'Invalid token'
  meta Authorization: 'Bearer <%=access_token%>'
  returns code: :ok do
    property :id, String, desc: 'The player\'s id'
    property :email, String, desc: 'The players Email'
    property :avatar, String, desc: 'the players avatar link', required: false
    property :confirmed_at, String, desc: 'the players avatar link', required: false
    property :created_at, String, desc: 'the players avatar link'
    property :updated_at, String, desc: 'the players avatar link'
  end
  def show; end

  api :GET, '/players/:id'
  param :id, :number, desc: 'id of the requested player'
  description 'show a player\'s information'
  error :not_found, 'Player Not Found'
  error :unauthorized, 'Invalid token'
  meta Authorization: 'Bearer <%=access_token%>'
  returns code: :ok do
    property :id, String, desc: 'The player\'s id'
    property :email, String, desc: 'The players Email'
    property :avatar, String, desc: 'the players avatar link', required: false
    property :confirmed_at, String, desc: 'the players avatar link', required: false
    property :created_at, String, desc: 'the players avatar link'
    property :updated_at, String, desc: 'the players avatar link'
  end
  def update; end
end
