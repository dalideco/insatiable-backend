# Documentation for offers routes
module OffersControllerDocs
  extend Apipie::DSL::Concern

  api :POST, '/offers'
  meta Authorization: 'Bearer <%=access_token%>'
  error :bad_request, 'Missing parameter'
  error :not_found, 'Player doesn not own the weapon'
  param :minimum_bid, :number, required: true
  param :buy_now_price, :number, required: true
  param :weapon_id, :number, required: true
  param :lifetime, [
    '1.hour',
    '3.hours',
    '6.hours',
    '12.hours',
    '1.day',
    '3.days',
    '30.seconds'
  ], required: true
  returns code: :ok do
    property :success, [true, false], desc: 'Whether the creationg was successful'
    property :offer, Hash, desc: 'Created offer object' do
      property :success, [true, false], desc: 'The player\'s id'
      property :minimum_bid, String, desc: 'Minimum bid for the offer'
      property :buy_now_price, String, desc: 'The buy now price'
      property :current_bid, String, desc: 'latest bid', required: false
      property :player_id, String, desc: 'id of the player'
      property :weapon_id, String, desc: 'id of the weapon'
      property :created_at, String, desc: 'the offer creating date & time'
      property :updated_at, String, desc: 'the last update date & time'
    end
  end
  def create; end
end
