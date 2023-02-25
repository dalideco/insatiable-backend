# Docs for owned packs
module OwnPacksControllerDocs
  extend Apipie::DSL::Concern

  api :POST, '/own_packs/:id/open'
  description "
  Enables player to buy a pack. \n
  a new own_pack object is created with the user_id and pack_id.
  "
  error :not_found, 'Pack Not Found'
  error :unauthorized, 'Invalid token'
  error :precondition_failed, 'Player coin balance insufficient'
  meta Authorization: 'Bearer <%=access_token%>'
  returns code: :ok do
    property :success, [true, false], desc: 'Whether the pack was opened or not'
    property :data, Hash, desc: 'Array of obtained weapons'
  end
  def open; end
end
