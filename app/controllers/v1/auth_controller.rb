module V1
  # authentication controller
  class AuthController < ApplicationController
    include AuthControllerDocs

    before_action :authorize_request, except: :login

    # login route
    def login
      @player = Player.find_by(email: login_params[:email])

      if @player&.authenticate(login_params[:password])
        token = JsonWebToken.encode(player_id: @player.id)
        time = Time.zone.now + 24.hours.to_i
        render json: { token:, exp: time.strftime('%m-%d-%Y %H:%M'),
                       email: @player.email }, status: :ok
      else
        render status: :unauthorized, json: {
          'error' => 'Unauthorized',
          'message' => 'Email or password incorrect'
        }
      end
    end

    def whoami
      player = Player.find_by!(id: @current_player.id)
      render json: {
        success: true,
        player: {
          id: player.id,
          email: player.email,
          avatar: player.avatar,
          coins: player.coins
        }
      }
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, json: {
        success: false,
        error: 'player not found'
      }
    end

    private

    def login_params
      params.require(:email)
      params.require(:password)
      params.permit(:email, :password)
    end
  end
end
