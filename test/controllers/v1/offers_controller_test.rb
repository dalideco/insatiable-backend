require 'test_helper'

module V1
  class OffersControllerTest < ActionController::TestCase
    test 'Create: should create an offer' do
      authenticate
      post :create, params: {
        minimum_bid: 500,
        buy_now_price: 800,
        weapon_id: 1,
        lifetime: '1.hour'
      }
      assert_response :ok
      json_response = JSON.parse(response.body)
      assert_equal json_response['success'], true
      assert_not_nil json_response['offer']
    end

    test 'Create: Should not create an offer when not authenticated' do
      post :create, params: {
        minimum_bid: 500,
        buy_now_price: 800,
        weapon_id: 1
      }
      assert_response :unauthorized
      json_response = JSON.parse(response.body)
      assert_equal json_response, { 'success' => false, 'errors' => 'Nil JSON web token' }
    end

    test 'Create: Should not have missing params' do
      authenticate
      post :create, params: {
        minimum_bid: 500,
        weapon_id: 1
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
        weapon_id: 1
      }
      # assert_response :ok
      json_response = JSON.parse(response.body)
      assert_equal json_response, { 'error' => 'Player 2 does not own weapon 1' }
    end
  end
end
