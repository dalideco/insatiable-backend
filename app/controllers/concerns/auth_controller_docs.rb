# Docs for authentication
module AuthControllerDocs
  extend Apipie::DSL::Concern

  api :POST, '/auth/login'
  description 'login using email and password'
  error :bad_request, 'Bad parameters: missing email or password'
  error :unauthorized, 'Invalid web token'
  returns code: :ok do
    property :token, String, desc: 'Authorization token'
    property :email, String, desc: 'Email of the authenticated player'
  end
  def login; end

  api :GET, '/auth/whoami'
  description 'identifying user'
  error :unauthorized, 'Invalid web token'
  returns code: :ok do
    property :success, [true, false]
    property :player, Hash, desc: 'authenticated player, contains also the owned weapons and packs'
  end
  def whoami; end
end
