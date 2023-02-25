# Docs for player controller routes
module PacksControllerDocs
  extend Apipie::DSL::Concern

  api :POST, '/packs/:id/buy'
  description "
  Enables player to buy a pack. \n
  a new own_pack object is created with the user_id and pack_id.
  "
  error :not_found, 'Pack Not Found'
  error :unauthorized, 'Invalid token'
  error :precondition_failed, 'Player coin balance insufficient'
  meta Authorization: 'Bearer <%=access_token%>'
  returns code: :ok do
    property :success, [true, false], desc: 'Whether the pack is bought or not'
    property :data, Hash, desc: 'Own Data object information' do
      property :id, Integer, desc: 'Own pack object id'
      property :player_id, Integer, desc: 'Id of owning player'
      property :pack_id, Integer, desc: 'Id of pack'
      property :created_at, String, desc: 'Date of creation'
      property :updated_at, String, desc: 'Date of update'
    end
  end
  def buy; end
end
