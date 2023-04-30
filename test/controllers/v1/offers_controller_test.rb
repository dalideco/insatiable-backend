require 'test_helper'

module V1
  class OffersControllerTest < ActionController::TestCase
    setup do
      @offer = offers(:one)
      @offer_two = offers(:two)
      @offer_expired = offers(:expired)
      @offer_sold = offers(:sold)
      @offer_expensive = offers(:expensive)
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

    # Bidding
    test 'Bid: Should bid on an offer' do
      authenticate
      patch :bid, params: {
        id: @offer_two.id,
        bid: 200
      }

      # verify response
      assert_response :ok
      json_response = JSON.parse(response.body)
      assert_equal json_response['success'], true
      assert_equal json_response['offer']['id'], @offer_two.id

      # verify bid added
      offer_two = Offer.find_by!(id: @offer_two.id)
      assert_equal offer_two.current_bid, 200
      assert_equal offer_two.bid?, true

      # verify price has been decucted
      player = Player.find_by!(id: @player.id)
      assert_equal player.coins, @player.coins - 200
    end

    test 'Bid: Player should not be able to bid when unauthenticated' do
      patch :bid, params: {
        id: @offer.id,
        bid: 200
      }
      assert_response :unauthorized

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'errors' => 'Nil JSON web token'
      }
    end

    test 'Bid: Player should not be able to bid on his offer' do
      authenticate
      patch :bid, params: {
        id: @offer.id,
        bid: 200
      }
      assert_response :conflict

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Player cannot bid on his offer'
      }
    end

    test 'Bid: Player should not be able to bid on an expired offer' do
      # Expired
      authenticate
      patch :bid, params: {
        id: @offer_expired.id,
        bid: 200
      }
      assert_response :not_acceptable

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'The offer is expired'
      }

      # Sold
      authenticate
      patch :bid, params: {
        id: @offer_sold.id,
        bid: 200
      }
      assert_response :not_acceptable

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'The offer is expired'
      }
    end

    test 'Bid: Player should not be able to bid with less than the min price' do
      authenticate
      patch :bid, params: {
        id: @offer_two.id,
        bid: 50
      }
      assert_response :conflict

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Entered bid price is lower than the minimum'
      }
    end

    test 'Bid: Player should not be able to bid with less than the current bid' do
      # first bid
      authenticate
      patch :bid, params: {
        id: @offer_two.id,
        bid: 200
      }
      assert_response :ok

      # second bid
      authenticate
      patch :bid, params: {
        id: @offer_two.id,
        bid: 200
      }
      assert_response :conflict

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Entered bid price is lower than the minimum'
      }
    end

    test 'Bid: Player should not be able to bid with more than the buy now price' do
      # first bid
      authenticate
      patch :bid, params: {
        id: @offer_two.id,
        bid: 400
      }
      assert_response :conflict

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Entered bid price is higher than the buy now price'
      }
    end

    test 'Bid: Player should not be able to bid with more than balance' do
      authenticate
      patch :bid, params: {
        id: @offer_expensive.id,
        bid: 1100
      }

      # verify response
      assert_response :payment_required
      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Insufficient balance'
      }
    end

    test 'Buy: Player should be able to buy an offer' do
      offer_player = Player.find_by!(id: @offer_two.player_id)

      authenticate
      post :buy, params: {
        id: @offer_two.id
      }

      assert_response :ok
      json_response = JSON.parse(response.body)
      assert_equal json_response['success'], true
      assert_not_nil json_response['weapon']
      assert_equal json_response['weapon']['id'], @offer_two.weapon_id

      # verify player now owns weapon
      own = Own.find_by!(player_id: @player.id, weapon_id: @offer_two.weapon_id)
      assert_not_nil own

      # verify offer is sold
      offer = Offer.find_by!(id: @offer_two.id)
      assert_equal offer.sold?, true

      # verify price has been deducted
      player = Player.find_by!(id: @player.id)
      assert_equal player.coins, @player.coins - @offer_two.buy_now_price

      # verify offer player has added the price
      new_offer_player = Player.find_by!(id: @offer_two.player_id)
      assert_equal new_offer_player.coins, offer_player.coins + @offer_two.buy_now_price
    end

    test 'Buy: Player should not buy when unauthenticated' do
      post :buy, params: {
        id: @offer_two.id
      }

      assert_response :unauthorized

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'errors' => 'Nil JSON web token'
      }
    end

    test 'Buy: Player should not buy his own offer' do
      authenticate
      post :buy, params: {
        id: @offer.id
      }

      assert_response :conflict

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Player cannot bid on his offer'
      }
    end

    test 'Buy: Player should not buy an expired offer' do
      authenticate
      post :buy, params: {
        id: @offer_expired.id
      }

      assert_response :not_acceptable

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'The offer is expired'
      }
    end

    test 'Buy: Player should have enough coins to buy' do
      authenticate
      post :buy, params: {
        id: @offer_expensive.id
      }

      assert_response :payment_required

      json_response = JSON.parse(response.body)
      assert_equal json_response, {
        'success' => false,
        'error' => 'Insufficient balance'
      }
    end
  end
end
