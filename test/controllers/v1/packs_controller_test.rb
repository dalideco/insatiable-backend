require 'test_helper'

module V1
  class PacksControllerTest < ActionController::TestCase
    setup do
      @pack = packs(:one)
      @expensive_pack = packs(:four)
    end
    test 'Buy: Should buy player' do
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
  end
end
