require 'test_helper'

module V1
  # Controller tests for pack
  class PacksControllerTest < ActionController::TestCase
    setup do
      @pack = packs(:one)
      @second_pack = packs(:two)
      @expensive_pack = packs(:four)
    end
    test 'Buy: Should buy pack' do
      authenticate

      # check that buy returns the right response
      post :buy, params: {
        id: @pack.id
      }
      response_pack = JSON.parse(response.body)['own_pack']
      assert_response :success

      # check that it has been added to own packsk
      own_pack = OwnPack.find_by(id: response_pack['id'])
      assert_not_nil own_pack
      assert_equal own_pack.player_id, @player.id
      assert_equal own_pack.pack_id, @pack.id

      # verify price has been deduced
      player = Player.find_by!(id: @player.id)
      assert_equal player.coins, @player.coins - @pack.price
    end
    test 'Buy: Should not buy an inexistant pack' do
      authenticate

      post :buy, params: {
        id: 999
      }

      assert_response :not_found
    end
    test 'Buy: Should not buy when unauthenticated' do
      post :buy, params: {
        id: @pack.id
      }

      response_body = JSON.parse(response.body)

      assert_response :unauthorized
      assert_equal response_body, {
        'success' => false,
        'errors' => 'Nil JSON web token'
      }
    end
    test 'Buy: Should not buy when player does not have enough coins' do
      authenticate

      post :buy, params: {
        id: @expensive_pack.id
      }
      response_body = JSON.parse(response.body)

      assert_response :payment_required
      assert_equal response_body, {
        'success' => false,
        'errors' => 'Insufficient balance of coins'
      }
    end

    test 'mine: Should get the player\'s packs' do
      authenticate

      get :mine, params: {
        player_id: @player.id
      }

      response_body = JSON.parse(response.body)
      assert_response :success
      assert_equal response_body, {
        'success' => true,
        'packs' => @player.owned_packs.as_json
      }
    end
    test 'mine: Should not get the packs for an unauthenticated player' do
      get :mine, params: {
        player_id: @player.id
      }

      response_body = JSON.parse(response.body)
      assert_response :unauthorized
      assert_equal response_body, {
        'success' => false,
        'errors' => 'Nil JSON web token'
      }
    end
    test 'mine: Should not get the packs for a different player' do
      authenticate
      get :mine, params: {
        player_id: @second_player.id
      }

      response_body = JSON.parse(response.body)
      assert_response :unauthorized
      assert_equal response_body, {
        'success' => false,
        'errors' => 'Not allowed to view this player\'s packs'
      }
    end

    test 'Open: Should open a pack' do
      authenticate

      # getting own_pack
      own_pack = OwnPack.find_by!(player_id: @player.id, pack_id: @pack.id)

      # run open route
      post :open, params: { player_id: @player.id, pack_id: @pack.id }
      response_body = JSON.parse(response.body)
      response_weapon = response_body['weapon']

      # verify response
      assert_response :success
      assert_equal response_body['success'], true
      assert_not_nil response_weapon

      # verify weapon has been added to player
      assert_includes @player.owned_weapons.as_json, response_weapon

      # verify pack has been removed
      searched_own_pack = OwnPack.find_by(id: own_pack.id)
      assert_nil searched_own_pack
    end
    test 'Open: Should not open a pack when unauthenticated' do
      post :open, params: { player_id: @player.id, pack_id: @pack.id }
      response_body = JSON.parse(response.body)
      assert_response :unauthorized
      assert_equal response_body, {
        success: false,
        errors: 'Nil JSON web token'
      }.as_json
    end
    test 'Open: Should not open a pack when not the same player' do
      authenticate
      post :open, params: { player_id: @second_player.id, pack_id: @second_pack.id }
      response_body = JSON.parse(response.body)
      assert_response :unauthorized
      assert_equal response_body, {
        success: false,
        errors: 'Not allowed to view this player\'s packs'
      }.as_json
    end
    test 'Open: Should not open a pack the player does not own' do
      authenticate
      post :open, params: { player_id: @player.id, pack_id: @expensive_pack.id }
      response_body = JSON.parse(response.body)
      assert_response :unauthorized
      assert_equal response_body, {
        success: false,
        errors: 'Cannot open an not owned pack'
      }.as_json
    end
  end
end
