require 'test_helper'

module V1
  class OffersControllerTest < ActionController::TestCase
    setup do
      @offer = offers(:one)
    end

    test 'Create: should create an offer' do
      own = Own.find_by!(player_id: @player.id, weapon_id: 1)

      authenticate
      post :create, params: {
        minimum_bid: 500,
        buy_now_price: 800,
        weapon_id: 1,
        lifetime: '1.hour'
      }
      assert_response :ok
      json_response = JSON.parse(response.body)
      response_weapon = json_response['offer']
      assert_equal json_response['success'], true
      assert_not_nil response_weapon

      # check weapon has been removed from player's owns
      new_own = Own.find_by(player_id: @player.id, weapon_id: 1)
      assert_not_equal new_own.id, own.id unless new_own.nil?

      # check offer has been created
      offer = Offer.find_by(id: response_weapon['id'])
      assert_not_nil offer
      assert_equal offer.minimum_bid, 500
      assert_equal offer.buy_now_price, 800
      assert_equal offer.weapon_id, 1
      assert_equal offer.lifetime, '1.hour'
    end

    test 'Create: Should not create an offer when not authenticated' do
      post :create, params: {
        minimum_bid: 500,
        buy_now_price: 800,
        weapon_id: 1,
        lifetime: '1.hour'
      }
      assert_response :unauthorized
      json_response = JSON.parse(response.body)
      assert_equal json_response, { 'success' => false, 'errors' => 'Nil JSON web token' }
    end

    test 'Create: Should not have missing params' do
      authenticate
      post :create, params: {
        minimum_bid: 500,
        weapon_id: 1,
        lifetime: '1.hour'
      }
      assert_response :bad_request
      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'error' => 'Bad request',
        'message' => 'param is missing or the value is empty: buy_now_price'
      }
    end

    test 'Create: Should not create offer when player does not own the weapon' do
      @request.headers['AUTHORIZATION'] = "Bearer #{@second_player_token}"
      post :create, params: {
        minimum_bid: 500,
        buy_now_price: 800,
        weapon_id: 1,
        lifetime: '1.hour'
      }
      # assert_response :ok
      json_response = JSON.parse(response.body)
      assert_equal json_response, { 'success' => false, 'error' => "Player doesn't own weapon" }
    end

    
  end
end
