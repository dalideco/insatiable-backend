require 'test_helper'

module V1
  class AuthControllerTest < ActionController::TestCase
    test 'Should login with valid credentials' do
      post :login, params: {
        email: @player.email,
        password: @player_password
      }
      json_response = JSON.parse(response.body)

      # response should succeed
      assert_response :success
      # response should contain token
      assert_not_nil json_response['token']
    end

    test 'Should not login with a missed credential' do
      # email missing
      post :login, params: {
        password: @player_password
      }
      assert_response :bad_request
      assert_equal JSON.parse(response.body), {
        'error' => 'Bad request',
        'message' => 'param is missing or the value is empty: email'
      }
      # password missing
      post :login, params: {
        email: @player.email
      }
      assert_response :bad_request
      assert_equal JSON.parse(response.body), {
        'error' => 'Bad request',
        'message' => 'param is missing or the value is empty: password'
      }
    end

    test 'Should not login with inexistant email' do
      post :login, params: {
        email: 'some_random_email@some_random_email',
        password: @player_password
      }

      assert_response :unauthorized
      assert_equal JSON.parse(response.body), {
        'error' => 'Unauthorized',
        'message' => 'Email or password incorrect'
      }
    end

    test 'Should not login with wrong password' do
      post :login, params: {
        email: @player.email,
        password: 'some_wrong_password'
      }

      assert_response :unauthorized
      assert_equal JSON.parse(response.body), {
        'error' => 'Unauthorized',
        'message' => 'Email or password incorrect'
      }
    end
  end
end
