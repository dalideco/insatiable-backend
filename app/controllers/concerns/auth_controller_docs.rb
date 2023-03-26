# Docs for authentication
module AuthControllerDocs
  extend Apipie::DSL::Concern

  api :POST, '/auth/login'
  description 'login using email and password'
  error :bad_request, 'Bad parameters: missing email or password'
  returns code: :ok do
    property :token, String, desc: 'Authorization token'
    property :email, String, desc: 'Email of the authenticated player'
  end
  def login; end
end
