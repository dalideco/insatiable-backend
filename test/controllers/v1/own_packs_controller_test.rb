require 'test_helper'

module V1
  class OwnPacksControllerTest < ActionController::TestCase
    setup do
      @own_pack = own_packs(:one)
      @own_pack_not_owned = own_packs(:two)
    end

    test 'Open: Should open a pack' do
      authenticate

      post :open, params: {
        id: @own_pack.id
      }

      assert_response :success

      # verify owned pack has been removed once opened
      own_pack = OwnPack.find_by(id: @own_pack.id)
      assert_nil own_pack
    end
    test 'Open: Should not open a pack when is not authenticated' do
      post :open, params: {
        id: @own_pack.id
      }

      response_body = JSON.parse(response.body)

      assert_response :unauthorized
      assert_equal response_body, {
        'success' => false,
        'errors' => 'Nil JSON web token'
      }
    end
    test 'Open: Should not open a pack that does not exist' do
      authenticate

      post :open, params: {
        id: 999
      }

      assert_response :not_found
    end
    test 'Open: Should not open a pack without owning it' do
      authenticate

      post :open, params: {
        id: @own_pack_not_owned.id
      }
      response_body = JSON.parse(response.body)

      assert_response :unauthorized
      assert_equal response_body, {
        'success' => false,
        'message' => "This item doesn't belong to the authenticated player"
      }
    end
  end
end
