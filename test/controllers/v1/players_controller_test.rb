require 'test_helper'

module V1
  class PlayersControllerTest < ActionController::TestCase
    setup do
      @player2 = players(:two)
    end

    # Create
    test 'Create: Should signup a player' do
      post :create, params: {
        email: 'test@test.test',
        password: 'test',
        password_confirmation: 'test'
      }
      assert_response :success
    end

    test 'Create: Should return bad request when an argument is missing' do
      # missing email
      post :create, params: {
        password: 'test',
        password_confirmation: 'test'
      }
      assert_response :bad_request

      # missing password
      post :create, params: {
        email: 'test@test.test',
        password_confirmation: 'test'
      }
      assert_response :bad_request

      # missing password confirmation
      post :create, params: {
        email: 'test@test.test',
        password: 'test'
      }
      assert_response :bad_request
    end

    # Index
    test 'Index: Should not be allowed for unauthorized users' do
      get :index
      assert_response :unauthorized
    end

    test 'Index: Should get players' do
      @request.headers['AUTHORIZATION'] = "Bearer #{@player_token}"
      get :index
      assert_response :success
      # make sure response does not inclues password
      assert_not_includes @response.body, 'password_digest'
    end

    # Update
    test 'Update: Should not update without authentication' do
      patch :update, params: { id: @player.id, avatar: 'test' }
      assert_response :unauthorized
    end

    test 'Update: Should update Player' do
      @request.headers['AUTHORIZATION'] = "Bearer #{@player_token}"
      patch :update, params: { id: @player.id, avatar: 'test' }
      assert_response :success
      # asserts player.avatar really equal 'test'
      assert_equal(Player.find_by(id: @player.id).avatar, 'test')
    end

    test 'Update: Should not update a different Player' do
      @request.headers['AUTHORIZATION'] = "Bearer #{@player_token}"
      patch :update, params: { id: @player2.id, avatar: 'test' }
      assert_response :unauthorized
    end

    # Show
    test 'Show: Should not show without authentication' do
      get :show, params: { id: @player.id }
      assert_response :unauthorized
    end

    test 'Show: Should show player' do
      @request.headers['AUTHORIZATION'] = "Bearer #{@player_token}"
      get :show, params: { id: @player.id }
      assert_response :success
      # make sure response does not inclues password
      assert_not_includes @response.body, 'password_digest'
    end
  end
end
