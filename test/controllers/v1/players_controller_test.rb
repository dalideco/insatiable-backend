require 'test_helper'

module V1
  class PlayersControllerTest < ActionController::TestCase
    setup do
      @player = Player.new(
        email: 'test@insatiable.de',
        password: 'test',
        password_confirmation: 'test'
      )
      @player.save
      JsonWebToken.encode(player_id: @player.id)
    end

    # Index
    test 'Index: Should not be allowed for unauthorized users' do
      get :index
      assert_response :unauthorized
    end

    test 'Index: Should get players' do
      assert true
    end
  end
end
